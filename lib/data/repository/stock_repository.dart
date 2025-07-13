import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/admin/stock_request_model.dart';
import 'package:galongo/data/model/response/stock_response_model.dart';
import 'package:galongo/data/model/response/stock_list_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class StockRepository {
  final ServiceHttpClient _httpClient;

  StockRepository(this._httpClient);

  Future<Either<String, StockResponseModel>> addStock(
      StockRequestModel request) async {
    try {
      final response = await _httpClient.postWithToken(
        "admin/stocks",
        request.toMap(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        return Right(StockResponseModel.fromMap(jsonResponse));
      } else {
        return Left(jsonResponse["message"] ?? "Failed to add stock");
      }
    } catch (e) {
      return Left("Error adding stock: $e");
    }
  }

  Future<Either<String, List<StockData>>> getAllStock() async {
    try {
      final response = await _httpClient.get("admin/stocks");

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final listResponse = StockListResponseModel.fromMap(jsonResponse);
        return Right(listResponse.data ?? []);
      } else {
        return Left(jsonResponse["message"] ?? "Failed to fetch stock");
      }
    } catch (e) {
      return Left("Error fetching stock list: $e");
    }
  }
}
