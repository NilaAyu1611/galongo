import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  // final String baseUrl = 'http://10.0.2.2:8000/api/';
  final String baseUrl = 'http://192.168.100.9:8000/api/';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // POST tanpa token (misalnya untuk login, register)
  Future<http.Response> post(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endPoint");
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }

  // POST dengan token (untuk endpoint yang butuh auth)
  Future<http.Response> postWithToken(String endPoint, Map<String, dynamic> body) async {
    final token = await _storage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endPoint");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception("POST with token failed: $e");
    }
  }

  // GET dengan token
  Future<http.Response> get(String endPoint) async {
    final token = await _storage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endPoint");

     print('🔐 Token: $token');
    print('🌐 URL: $baseUrl$endPoint');


    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }

  // DELETE dengan token
  Future<http.Response> delete(String endPoint) async {
    final token = await _storage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endPoint");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("DELETE request failed: $e");
    }
  }
}
