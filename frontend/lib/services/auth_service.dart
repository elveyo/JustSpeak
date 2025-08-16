import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  String? _jwt;
  Map<String, dynamic>? _decoded;

  // Set JWT in memory + storage
  Future<void> saveToken(String token) async {
    _jwt = token;
    _decoded = JwtDecoder.decode(token);
    await _storage.write(key: 'jwt', value: token);
  }

  // Load JWT from storage
  Future<void> loadToken() async {
    _jwt = await _storage.read(key: 'jwt');
    if (_jwt != null) {
      _decoded = JwtDecoder.decode(_jwt!);
    }
  }

  // Check if token is expired
  bool get isLoggedIn {
    if (_jwt == null) return false;
    return !JwtDecoder.isExpired(_jwt!);
  }

  // Get current user id
  int? get userId => int.tryParse(
    _decoded?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
        '',
  );

  // Get raw JWT
  String? get token => _jwt;
  Map<String, dynamic>? get decoded => _decoded;

  // Logout
  Future<void> logout() async {
    _jwt = null;
    _decoded = null;
    await _storage.delete(key: 'jwt');
  }
}
