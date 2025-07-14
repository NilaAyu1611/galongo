import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/customer/transaction_request_model.dart';
import 'package:galongo/data/model/response/customer/transaction_response_model.dart';
import 'package:galongo/data/model/response/transaction_summary_respon_mode.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class TransactionRepository {
  final ServiceHttpClient _httpClient;

  TransactionRepository(this._httpClient);

  // POST: Membuat transaksi baru
  Future<Either<String, TransactionResponseModel>> createTransaction(TransactionRequestModel request) async {
    try {
      final http.Response response = await _httpClient.postWithToken("customer/transactions", request.toMap());
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final transactionResponse = TransactionResponseModel.fromMap(jsonResponse);
        log(" Transaksi berhasil dibuat: ${transactionResponse.message}");
        return Right(transactionResponse);
      } else {
        log(" Gagal membuat transaksi: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal membuat transaksi");
      }
    } catch (e) {
      log(" Error saat membuat transaksi: $e");
      return Left("Terjadi kesalahan saat membuat transaksi: $e");
    }
  }

  // GET: Mendapatkan semua transaksi
  Future<Either<String, List<String>>> getAllTransactions() async {
    try {
      final http.Response response = await _httpClient.get("customer/transactions");
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        // Misalnya data-nya berupa list of strings (ubah jika struktur beda)
        final List<String> transactions = List<String>.from(jsonResponse['data']);
        log(" Ambil transaksi berhasil");
        return Right(transactions);
      } else {
        log(" Gagal mengambil data transaksi: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal mengambil data transaksi");
      }
    } catch (e) {
      log(" Error saat mengambil transaksi: $e");
      return Left("Terjadi kesalahan saat mengambil transaksi: $e");
    }
  }

  //===================Admin======================
  
  Future<Either<String, List<TransactionData>>> getAdminTransactions() async {
    try {
      final res = await _httpClient.get("admin/transactions");
      final body = json.decode(res.body);
      if (res.statusCode == 200) {
        final List<TransactionData> transactions =
            (body['data'] as List).map((e) => TransactionData.fromMap(e)).toList();
        return Right(transactions);
      } else {
        return Left(body['message'] ?? 'Gagal mengambil data');
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

  Future<Either<String, TransactionSummary>> getAdminTransactionSummary() async {
    try {
      final res = await _httpClient.get("admin/transactions/summary");
      final body = json.decode(res.body);
      if (res.statusCode == 200) {
        return Right(TransactionSummary.fromMap(body['data']));
      } else {
        return Left(body['message'] ?? 'Gagal mengambil ringkasan');
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

}
