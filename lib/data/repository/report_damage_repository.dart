import 'dart:convert';
import 'dart:developer';

import 'package:galongo/data/model/request/customer/report_damage_request_model.dart';
import 'package:galongo/data/model/response/customer/report_damage_response_model.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:dartz/dartz.dart';

class ReportDamageRepository {
  final ServiceHttpClient _httpClient;

  ReportDamageRepository(this._httpClient);

  Future<Either<String, ReportDamageResponseModel>> reportDamage(
    ReportDamageRequestModel request,
  ) async {
    try {
      final response = await _httpClient.postWithToken(
        "customer/report-damage",
        request.toMap(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final result = ReportDamageResponseModel.fromMap(jsonResponse);
        log("Damage Report Success: ${result.message}");
        return Right(result);
      } else {
        return Left(jsonResponse["message"] ?? "Failed to report damage");
      }
    } catch (e) {
      return Left("Error reporting damage: $e");
    }
  }
}
