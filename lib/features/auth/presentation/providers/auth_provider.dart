import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/vehiculos/data/models/vehiculo_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/registro_usecase.dart';
import '../../domain/usecases/activar_cuenta_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/olvidar_clave_usecase.dart';
import '../../domain/usecases/get_perfil_usecase.dart';
import '../../domain/usecases/update_foto_perfil_usecase.dart';

// ── Infraestructura ──────────────────────────────────────────────────────────

final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ApiClient().dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(dataSource: ref.read(authDataSourceProvider));
});

final registroUseCaseProvider = Provider<RegistroUseCase>((ref) {
  return RegistroUseCase(ref.read(authRepositoryProvider));
});

final activarCuentaUseCaseProvider = Provider<ActivarCuentaUseCase>((ref) {
  return ActivarCuentaUseCase(ref.read(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final olvidarClaveUseCaseProvider = Provider<OlvidarClaveUseCase>((ref) {
  return OlvidarClaveUseCase(ref.read(authRepositoryProvider));
});

final getPerfilUseCaseProvider = Provider<GetPerfilUseCase>((ref) {
  return GetPerfilUseCase(ref.read(authRepositoryProvider));
});

final updateFotoPerfilUseCaseProvider =
    Provider<UpdateFotoPerfilUseCase>((ref) {
  return UpdateFotoPerfilUseCase(ref.read(authRepositoryProvider));
});

// ── Estado de autenticación ──────────────────────────────────────────────────

class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final List<VehiculoModel> misVehiculos;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.misVehiculos = const [],
  });

  bool get isAuthenticated => user != null && user!.token.isNotEmpty;
  String? get vehiculoId => user?.vehiculoId;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    List<VehiculoModel>? misVehiculos,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      misVehiculos: misVehiculos ?? this.misVehiculos,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState()) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final storage = LocalStorage();
    final token = storage.getToken();
    if (token != null && token.isNotEmpty) {
      final vehiculoId = storage.getVehiculoId();
      final apellido = storage.getUserApellido() ?? '';

      state = AuthState(
        user: UserEntity(
          id: storage.getUserId() ?? '',
          nombre: storage.getUserNombre() ?? '',
          apellido: apellido,
          matricula: '',
          token: token,
          refreshToken: storage.getRefreshToken(),
          fotoUrl: storage.getUserFoto(),
          vehiculoId: vehiculoId,
        ),
      );

      print('📱 Sesión cargada desde storage - Vehículo ID: $vehiculoId');

      if (vehiculoId == null || vehiculoId.isEmpty) {
        print('⚠️ Vehículo ID no encontrado en storage, cargando perfil...');
        await loadPerfil();
      }

      // Cargar vehículos del usuario
      await loadMisVehiculos();
    }
  }

  Future<String?> registro(String matricula) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(registroUseCaseProvider).call(matricula);
    state = state.copyWith(isLoading: false);
    return result.fold(
      (error) {
        state = state.copyWith(error: error);
        return null;
      },
      (tokenTemporal) => tokenTemporal,
    );
  }

  Future<bool> activarCuenta(String tokenTemporal, String contrasena) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref
        .read(activarCuentaUseCaseProvider)
        .call(tokenTemporal, contrasena);
    return result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
      (user) async {
        await _saveSession(user);
        state = state.copyWith(isLoading: false, user: user);
        await loadMisVehiculos();
        return true;
      },
    );
  }

  Future<bool> login(String matricula, String contrasena) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result =
        await ref.read(loginUseCaseProvider).call(matricula, contrasena);
    return result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
      (user) async {
        print('✅ Login exitoso - Usuario: ${user.nombre}');
        print('✅ Vehículo ID del login: ${user.vehiculoId}');

        await _saveSession(user);
        state = state.copyWith(isLoading: false, user: user);
        await loadPerfil();
        await loadMisVehiculos();

        return true;
      },
    );
  }

  Future<bool> olvidarClave(String matricula) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(olvidarClaveUseCaseProvider).call(matricula);
    state = state.copyWith(isLoading: false);
    return result.fold(
      (error) {
        state = state.copyWith(error: error);
        return false;
      },
      (_) => true,
    );
  }

  Future<void> loadPerfil() async {
    print('🔄 Cargando perfil completo del usuario...');

    final result = await ref.read(getPerfilUseCaseProvider).call();

    result.fold(
      (error) {
        print('❌ Error cargando perfil: $error');
      },
      (userProfile) {
        print('✅ Perfil cargado exitosamente:');
        print('   - ID: ${userProfile.id}');
        print('   - Vehículo ID: ${userProfile.vehiculoId ?? "NULL"}');

        final currentUser = state.user;
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            id: userProfile.id,
            nombre: userProfile.nombre,
            apellido: userProfile.apellido,
            matricula: userProfile.matricula,
            fotoUrl: userProfile.fotoUrl ?? currentUser.fotoUrl,
            correo: userProfile.correo,
            rol: userProfile.rol,
            grupo: userProfile.grupo,
            vehiculoId: userProfile.vehiculoId,
          );

          state = state.copyWith(user: updatedUser);
          _saveSession(updatedUser);
        }
      },
    );
  }

  // NUEVO: Cargar vehículos del usuario
  Future<void> loadMisVehiculos() async {
    print('🚗 Cargando vehículos del usuario...');

    final dataSource = ref.read(authDataSourceProvider);
    final vehiculos = await dataSource.getMisVehiculos();

    print('🚗 Vehículos encontrados: ${vehiculos.length}');
    for (var v in vehiculos) {
      print('   - ID: ${v.id}, ${v.marca} ${v.modelo}');
    }

    state = state.copyWith(misVehiculos: vehiculos);

    // Si el usuario no tiene vehiculoId pero tiene vehículos, usar el primero
    if ((state.user?.vehiculoId == null || state.user!.vehiculoId!.isEmpty) &&
        vehiculos.isNotEmpty) {
      print(
          '⚠️ Usuario sin vehículo asociado, asignando el primero: ${vehiculos.first.id}');
      final updatedUser = state.user?.copyWith(vehiculoId: vehiculos.first.id);
      if (updatedUser != null) {
        state = state.copyWith(user: updatedUser);
        _saveSession(updatedUser);
      }
    }
  }

  Future<bool> updateFoto(String filePath) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result =
        await ref.read(updateFotoPerfilUseCaseProvider).call(filePath);
    state = state.copyWith(isLoading: false);
    return result.fold(
      (error) {
        state = state.copyWith(error: error);
        return false;
      },
      (user) {
        final updated = state.user?.copyWith(fotoUrl: user.fotoUrl);
        if (updated != null) state = state.copyWith(user: updated);
        return true;
      },
    );
  }

  Future<void> logout() async {
    final storage = LocalStorage();
    await storage.clearAll();
    state = const AuthState();
  }

  Future<void> _saveSession(UserEntity user) async {
    final storage = LocalStorage();
    await storage.saveToken(user.token);
    if (user.refreshToken != null) {
      await storage.saveRefreshToken(user.refreshToken!);
    }
    await storage.saveUserData(
      id: user.id,
      nombre: user.nombre,
      apellido: user.apellido,
      foto: user.fotoUrl,
      vehiculoId: user.vehiculoId,
    );

    print('💾 Sesión guardada - Vehículo ID: ${user.vehiculoId}');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Provider para obtener el vehículo ID (prioriza vehículos del usuario)
final currentUserVehiculoIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authProvider);

  // Primero intentar con el vehiculoId del usuario
  if (authState.user?.vehiculoId != null &&
      authState.user!.vehiculoId!.isNotEmpty) {
    print('✅ Usando vehículo ID del usuario: ${authState.user!.vehiculoId}');
    return authState.user!.vehiculoId!;
  }

  // Si no tiene, usar el primer vehículo de su lista
  if (authState.misVehiculos.isNotEmpty) {
    print(
        '✅ Usando primer vehículo de la lista: ${authState.misVehiculos.first.id}');
    return authState.misVehiculos.first.id;
  }

  // Último recurso: ID de prueba (el que vimos en logs: ID 7)
  print('⚠️ Usando vehículo de prueba ID: 7');
  return '7';
});
