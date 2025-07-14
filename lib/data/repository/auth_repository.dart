import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:galongo/data/model/request/auth/login_request_model.dart';
import 'package:galongo/data/model/request/auth/register_request_model.dart';
import 'package:galongo/data/model/response/auth_response_mode.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final ServiceHttpClient _httpClient;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthRepository(this._httpClient);

  // LOGIN
  Future<Either<String, AuthResponseModel>> login(LoginRequestModel requestModel) async {
  try {
    final http.Response response = await _httpClient.post('login', requestModel.toMap());
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      final result = AuthResponseModel.fromMap(jsonResponse);

      final role = result.data?.role;
      if (role != null) {
        await _storage.write(key: 'userRole', value: role);
      }

      
      // Ambil token dari response
      final token = result.data?.token;

      if (token != null) {
        await _storage.write(key: 'authToken', value: token);
        log("🔐 Token tersimpan: $token");
      } else {
        log("❌ Token tidak ditemukan di response!");
      }

      // Debug: cek token tersimpan
      final savedToken = await _storage.read(key: 'authToken');
      log("🧪 Token saat request dashboard: $savedToken");

      return Right(result);
    } else {
      log("❌ Login gagal: ${jsonResponse['message']}");
      return Left(jsonResponse['message'] ?? 'Login failed');
    }
  } catch (e) {
    log("❌ Error selama login: $e");
    return Left('Terjadi error saat login: $e');
  }
}


  // REGISTER
  Future<Either<String, AuthResponseModel>> register(RegisterRequestModel requestModel) async {
    try {
      final http.Response response = await _httpClient.post('register', requestModel.toMap());
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = AuthResponseModel.fromMap(jsonResponse);
        log(" Registration successful");
        return Right(result);
      } else {
        log(" Registration failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? 'Registration failed');
      }
    } catch (e) {
      log(" Error during registration: $e");
      return Left('Error occurred during registration: $e');
    }
  }

  // LOGOUT
  Future<Either<String, String>> logout() async {
    try {
      final response = await _httpClient.postWithToken('logout', {});
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        await _storage.delete(key: 'authToken');
        log(" Logout successful");
        return Right(jsonResponse['message'] ?? 'Logout successful');
      } else {
        log(" Logout failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? 'Logout failed');
      }
    } catch (e) {
      log(" Error during logout: $e");
      return Left('Error occurred during logout: $e');
    }
  }

  // CEK TOKEN
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'authToken');
    return token != null;
  }
}
