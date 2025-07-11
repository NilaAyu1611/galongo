import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/admin/confirmation_request_mode.dart';
import 'package:galongo/data/model/response/confirmation_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class ConfirmationRepository {
  final ServiceHttpClient _httpClient;

  ConfirmationRepository(this._httpClient);

  Future<Either<String, ConfirmationResponseModel>> confirmOrder(
    ConfirmationRequestModel request,
  ) async {
    try {
      final response = await _httpClient.postWithToken(
        'admin/confirm', // pastikan ini endpoint yang sesuai di backend Laravel
        request.toMap(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = ConfirmationResponseModel.fromMap(jsonResponse);
        log("Order confirmed: ${result.message}");
        return Right(result);
      } else {
        log("Confirm order failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Failed to confirm order");
      }
    } catch (e) {
      log("Error confirming order: $e");
      return Left("An error occurred while confirming order: $e");
    }
  }
}
