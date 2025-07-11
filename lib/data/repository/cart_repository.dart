import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/customer/cart_request_model.dart';
import 'package:galongo/data/model/response/customer/cart_response_model.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class CartRepository {
  final ServiceHttpClient _httpClient;

  CartRepository(this._httpClient);

  // Tambahkan item ke cart
  Future<Either<String, CartResponseModel>> addToCart(CartRequestModel request) async {
    try {
      final http.Response response = await _httpClient.postWithToken("customer/cart", request.toMap());
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final cartResponse = CartResponseModel.fromMap(jsonResponse);
        log("✅ Berhasil tambah ke keranjang: ${cartResponse.message}");
        return Right(cartResponse);
      } else {
        log("❌ Gagal tambah ke keranjang: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal menambahkan ke keranjang");
      }
    } catch (e) {
      log("🔥 Error saat tambah ke cart: $e");
      return Left("Terjadi kesalahan saat menambahkan ke keranjang: $e");
    }
  }

  // Ambil semua item di cart
  Future<Either<String, CartResponseModel>> getCartItems() async {
    try {
      final http.Response response = await _httpClient.get("customer/cart");
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final cartResponse = CartResponseModel.fromMap(jsonResponse);
        log("Ambil cart berhasil");
        return Right(cartResponse);
      } else {
        log(" Gagal ambil cart: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal mengambil data keranjang");
      }
    } catch (e) {
      log(" Error saat mengambil cart: $e");
      return Left("Terjadi kesalahan saat mengambil keranjang: $e");
    }
  }

  // Hapus item dari cart
  Future<Either<String, String>> removeFromCart(int cartItemId) async {
    try {
      final response = await _httpClient.delete("customer/cart/$cartItemId");
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        log(" Item keranjang dihapus: ${jsonResponse['message']}");
        return Right(jsonResponse['message']);
      } else {
        log(" Gagal hapus item cart: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal menghapus item dari keranjang");
      }
    } catch (e) {
      log(" Error saat menghapus dari cart: $e");
      return Left("Terjadi kesalahan saat menghapus item dari keranjang: $e");
    }
  }
}
