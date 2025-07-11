import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/admin/stock_request_model.dart';
import 'package:galongo/data/model/response/stock_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class StockRepository {
  final ServiceHttpClient _httpClient;

  StockRepository(this._httpClient);

  // Tambah data stok
  Future<Either<String, StockResponseModel>> addStock(
      StockRequestModel request) async {
    try {
      final response = await _httpClient.postWithToken(
        "admin/stock", // sesuaikan endpoint
        request.toMap(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final result = StockResponseModel.fromMap(jsonResponse);
        log("Add Stock Successful: ${result.message}");
        return Right(result);
      } else {
        log("Add Stock Failed: ${jsonResponse["message"]}");
        return Left(jsonResponse["message"] ?? "Failed to add stock");
      }
    } catch (e) {
      log("Error adding stock: $e");
      return Left("Error adding stock: $e");
    }
  }

  // Dapatkan semua stok
  Future<Either<String, List<Data>>> getAllStock() async {
    try {
      final response = await _httpClient.get("admin/stock"); // sesuaikan endpoint

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<Data> stockList = List<Data>.from(
          jsonResponse['data'].map((x) => Data.fromMap(x)),
        );
        log("Fetch Stock List Success");
        return Right(stockList);
      } else {
        log("Fetch Stock List Failed: ${jsonResponse["message"]}");
        return Left(jsonResponse["message"] ?? "Failed to fetch stock");
      }
    } catch (e) {
      log("Error fetching stock list: $e");
      return Left("Error fetching stock list: $e");
    }
  }
}
