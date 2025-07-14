import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:galongo/data/model/response/dashboard_response_ model.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';



class DashboardRepository {
  final ServiceHttpClient _httpClient;

  DashboardRepository(this._httpClient);

  Future<Either<String, DashboardResponseModel>> getDashboardData() async {
  try {
    final response = await _httpClient.getWithToken('admin/dashboard');
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      final result = DashboardResponseModel.fromMap(jsonResponse);
      return Right(result);
    } else {
      return Left(jsonResponse['message'] ?? 'Gagal mengambil data dashboard');
    }
  } catch (e) {
    return Left('Terjadi kesalahan: $e');
  }
}

}
