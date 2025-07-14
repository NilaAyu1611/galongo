import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/customer/review_request_mode.dart';
import 'package:galongo/data/model/response/customer/review_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class ReviewRepository {
  final ServiceHttpClient _httpClient;

  ReviewRepository(this._httpClient);

  Future<Either<String, ReviewResponseModel>> submitReview(
    ReviewRequestModel request,
  ) async {
    try {
      final response = await _httpClient.postWithToken(
        "customer/review",
        request.toMap(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final result = ReviewResponseModel.fromMap(jsonResponse);
        log("Review Submitted Successfully: ${result.message}");
        return Right(result);
      } else {
        log("Review Submit Failed: ${jsonResponse["message"]}");
        return Left(jsonResponse["message"] ?? "Failed to submit review");
      }
    } catch (e) {
      log("Error submitting review: $e");
      return Left("Error submitting review: $e");
    }
  }

  Future<Either<String, List<dynamic>>> getAllReviews() async {
  try {
    final response = await _httpClient.get("admin/review");
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return Right(jsonResponse["data"] ?? []);
    } else {
      return Left(jsonResponse["message"] ?? "Failed to load reviews");
    }
  } catch (e) {
    return Left("Error loading reviews: $e");
  }
}
}
