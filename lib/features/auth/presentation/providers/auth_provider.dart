import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null && user!.token.isNotEmpty;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
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
      // Tenemos token guardado → marcar como autenticado con datos mínimos
      // El perfil completo se carga en PerfilScreen
      state = AuthState(
        user: UserEntity(
          id: storage.getUserId() ?? '',
          nombre: storage.getUserNombre() ?? '',
          apellido: '',
          matricula: '',
          token: token,
          refreshToken: storage.getRefreshToken(),
          fotoUrl: storage.getUserFoto(),
        ),
      );
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
        await _saveSession(user);
        state = state.copyWith(isLoading: false, user: user);
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
    final result = await ref.read(getPerfilUseCaseProvider).call();
    result.fold(
      (_) {},
      (user) {
        final updated = UserEntity(
          id: user.id,
          nombre: user.nombre,
          apellido: user.apellido,
          matricula: user.matricula,
          token: state.user?.token ?? '',
          refreshToken: state.user?.refreshToken,
          fotoUrl: user.fotoUrl,
          correo: user.correo,
          rol: user.rol,
          grupo: user.grupo,
        );
        state = state.copyWith(user: updated);
        _saveSession(updated);
      },
    );
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
      foto: user.fotoUrl,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
