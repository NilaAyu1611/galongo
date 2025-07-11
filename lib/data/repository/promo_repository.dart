import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/admin/promo_request_model.dart';
import 'package:galongo/data/model/response/promo_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class PromoRepository {
  final ServiceHttpClient _httpClient;

  PromoRepository(this._httpClient);

  // Tambah promo
  Future<Either<String, PromoResponseModel>> addPromo(
      PromoRequestModel request) async {
    try {
      final response = await _httpClient.postWithToken(
        "admin/promo", // sesuaikan dengan endpoint backend
        request.toMap(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final result = PromoResponseModel.fromMap(jsonResponse);
        log("Add Promo Success: ${result.message}");
        return Right(result);
      } else {
        log("Add Promo Failed: ${jsonResponse['message']}");
        return Left(jsonResponse["message"] ?? "Failed to add promo");
      }
    } catch (e) {
      log("Error adding promo: $e");
      return Left("Error adding promo: $e");
    }
  }

  // Get semua promo
  Future<Either<String, List<dynamic>>> getAllPromo() async {
    try {
      final response = await _httpClient.get("admin/promo"); // endpoint bisa disesuaikan
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final promoList = jsonResponse['data'] ?? [];
        log("Get Promo List Success");
        return Right(promoList);
      } else {
        log("Get Promo Failed: ${jsonResponse["message"]}");
        return Left(jsonResponse["message"] ?? "Failed to fetch promo");
      }
    } catch (e) {
      log("Error fetching promo: $e");
      return Left("Error fetching promo: $e");
    }
  }
}
