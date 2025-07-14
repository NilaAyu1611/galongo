import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/customer/order_request_model.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';
import 'package:galongo/services/service_http_client.dart';


class OrderRepository {
  final ServiceHttpClient _httpClient;

  OrderRepository(this._httpClient);

  // ============ CUSTOMER ============

  Future<Either<String, OrderResponseModel>> createOrder(OrderRequestModel requestModel) async {
    final response = await _httpClient.postWithToken('customer/orders', requestModel.toMap());
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Right(OrderResponseModel.fromMap(jsonResponse));
    } else {
      return Left(jsonResponse['message']);
    }
  }

  Future<Either<String, List<Data>>> getOrderHistory() async {
    final response = await _httpClient.get('customer/orders/history');
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<Data> data = (jsonResponse['data'] as List).map((e) => Data.fromMap(e)).toList();
      return Right(data);
    } else {
      return Left(jsonResponse['message']);
    }
  }

  Future<Either<String, String>> confirmOrderReceived(int id) async {
    final response = await _httpClient.postWithToken('customer/orders/$id/confirm', {});
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return Right(jsonResponse['message']);
    } else {
      return Left(jsonResponse['message']);
    }
  }

  // ============ ADMIN ============

  Future<Either<String, List<Data>>> getAllCustomerOrders() async {
    final response = await _httpClient.get('admin/customers/orders');
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<Data> data = (jsonResponse['data'] as List).map((e) => Data.fromMap(e)).toList();
      return Right(data);
    } else {
      return Left(jsonResponse['message']);
    }
  }

  Future<Either<String, Unit>> updateOrderByAdmin(int id, Map<String, dynamic> data) async {
  try {
    final response = await _httpClient.putWithToken("admin/orders/$id", data);
    if (response.statusCode == 200) {
      return Right(unit);
    } else {
      final message = json.decode(response.body)['message'] ?? 'Gagal update';
      return Left(message);
    }
  } catch (e) {
    return Left("Gagal update: $e");
  }
}


}