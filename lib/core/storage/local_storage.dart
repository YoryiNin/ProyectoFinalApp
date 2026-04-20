import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  late SharedPreferences _prefs;

  static const String _userIdKey = 'user_id';
  static const String _userNombreKey = 'user_nombre';
  static const String _userApellidoKey = 'user_apellido';
  static const String _userFotoKey = 'user_foto';
  static const String _vehiculoIdKey = 'vehiculo_id';

  static Future<void> init() async {
    _instance._prefs = await SharedPreferences.getInstance();
  }

  // ── Token ──────────────────────────────────────────────────────────────────
  Future<void> saveToken(String token) async =>
      _prefs.setString(AppConstants.tokenKey, token);

  String? getToken() => _prefs.getString(AppConstants.tokenKey);

  Future<void> saveRefreshToken(String token) async =>
      _prefs.setString(AppConstants.refreshTokenKey, token);

  String? getRefreshToken() => _prefs.getString(AppConstants.refreshTokenKey);

  // ── Datos del usuario ──────────────────────────────────────────────────────
  Future<void> saveUserData({
    required String id,
    required String nombre,
    String? apellido,
    String? foto,
    String? vehiculoId,
  }) async {
    await _prefs.setString(_userIdKey, id);
    await _prefs.setString(_userNombreKey, nombre);
    if (apellido != null) await _prefs.setString(_userApellidoKey, apellido);
    if (foto != null) await _prefs.setString(_userFotoKey, foto);
    if (vehiculoId != null) await _prefs.setString(_vehiculoIdKey, vehiculoId);
  }

  String? getUserId() => _prefs.getString(_userIdKey);
  String? getUserNombre() => _prefs.getString(_userNombreKey);
  String? getUserApellido() => _prefs.getString(_userApellidoKey);
  String? getUserFoto() => _prefs.getString(_userFotoKey);
  String? getVehiculoId() => _prefs.getString(_vehiculoIdKey);

  // ── Clear ──────────────────────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.refreshTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userNombreKey);
    await _prefs.remove(_userApellidoKey);
    await _prefs.remove(_userFotoKey);
    await _prefs.remove(_vehiculoIdKey);
  }
}
