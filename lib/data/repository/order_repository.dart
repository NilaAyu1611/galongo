import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/customer/order_request_model.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class OrderRepository {
  final ServiceHttpClient _httpClient;

  OrderRepository(this._httpClient);

  // Kirim pesanan baru (POST ke /customer/orders)
  Future<Either<String, OrderResponseModel>> createOrder(OrderRequestModel requestModel) async {
    try {
      final response = await _httpClient.postWithToken('customer/orders', requestModel.toMap());
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final order = OrderResponseModel.fromMap(jsonResponse);
        log(" Order created: ${order.message}");
        return Right(order);
      } else {
        log(" Order failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      log(" Error creating order: $e");
      return Left("Error occurred while creating order: $e");
    }
  }

  // Ambil riwayat order customer (GET ke /customer/orders/history)
  Future<Either<String, List<Data>>> getOrderHistory() async {
    try {
      final response = await _httpClient.get("customer/orders/history");
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = jsonResponse['data'];
        final orders = ordersJson.map((e) => Data.fromMap(e)).toList();
        log(" Order history fetched");
        return Right(orders);
      } else {
        log(" Fetch order history failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? 'Failed to fetch order history');
      }
    } catch (e) {
      log(" Error fetching order history: $e");
      return Left("Error occurred while fetching order history: $e");
    }
  }

  // Konfirmasi pesanan diterima (POST ke /customer/orders/{id}/confirm)
  Future<Either<String, String>> confirmOrderReceived(int orderId) async {
    try {
      final response = await _httpClient.postWithToken("customer/orders/$orderId/confirm", {});
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        log(" Order confirmed received");
        return Right(jsonResponse['message'] ?? "Order confirmed received");
      } else {
        log(" Confirm order failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Failed to confirm order");
      }
    } catch (e) {
      log(" Error confirming order: $e");
      return Left("Error occurred while confirming order: $e");
    }
  }
}
