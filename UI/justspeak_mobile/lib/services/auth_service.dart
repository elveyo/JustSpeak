import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user.dart';
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

  //    return !JwtDecoder.isExpired(_jwt!);

  // Get current user id
  User? get user {
    if (_decoded == null) return null;
    try {
      final id =
          int.tryParse(
            _decoded?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'],
          ) ??
          0;
      final firstName =
          _decoded?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname'] ??
          '';
      final lastName =
          _decoded?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname'] ??
          '';
      final role =
          _decoded?['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
          '';
      final imageUrl = _decoded?['imageUrl'] ?? '';

      return User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        role: role,
        imageUrl: imageUrl,
      );
    } catch (e) {
      return null;
    }
  }

  int? get userId => user?.id;

  bool get isAuthenticated => user != null && !JwtDecoder.isExpired(_jwt!);

  String? get token => _jwt;

  // Logout
  Future<void> logout() async {
    _jwt = null;
    _decoded = null;
    await _storage.delete(key: 'jwt');
  }
}
