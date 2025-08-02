import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'package:galongo/data/model/request/customer/report_damage_request_model.dart';
import 'package:galongo/data/model/response/customer/report_damage_response_model.dart';
import 'package:galongo/services/service_http_client.dart';

class ReportDamageRepository {
  final ServiceHttpClient _httpClient;

  ReportDamageRepository(this._httpClient);

  Future<Either<String, ReportDamageResponseModel>> reportDamage(
    ReportDamageRequestModel request,
    File imageFile, // ⬅️ kirim file asli dari kamera
  ) async {
    try {
      final uri = Uri.parse("${_httpClient.baseUrl}/customer/report-damage");
      final token = await _httpClient.getToken();

      var requestMultipart = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['order_id'] = request.orderId.toString()
        ..fields['description'] = request.description ?? ""
        ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path)); // ⬅️ kirim file sebagai foto

      final streamedResponse = await requestMultipart.send();
      final response = await http.Response.fromStream(streamedResponse);
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final result = ReportDamageResponseModel.fromMap(jsonResponse);
        return Right(result);
      } else {
        return Left(jsonResponse['message'] ?? "Gagal mengirim laporan kerusakan");
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat kirim laporan: $e");
    }
  }

  Future<Either<String, List<dynamic>>> getAllDamageReports() async {
    try {
      final response = await _httpClient.getWithToken("admin/damage-reports");
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return Right(jsonResponse["data"] ?? []);
      } else {
        return Left(jsonResponse["message"] ?? "Gagal memuat laporan");
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat memuat laporan: $e");
    }
  }

  Future<Either<String, String>> updateReportStatus(int id, String status) async {
  try {
    //final uri = Uri.parse("${_httpClient.baseUrl}/admin/damage-reports/$id");
    final uri = Uri.parse("${_httpClient.baseUrl.replaceAll(RegExp(r'/+$'), '')}/admin/damage-reports/$id");

    final token = await _httpClient.getToken();

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({"status": status}),
    );

    // Tambahkan pengecekan tipe konten
    if (!response.headers['content-type']!.contains('application/json')) {
      return Left("Response bukan JSON: ${response.body}");
    }

    // Coba decode JSON
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return Right(jsonResponse["message"] ?? "Status berhasil diperbarui");
    } else {
      return Left(jsonResponse["message"] ?? "Gagal memperbarui status");
    }
  } catch (e) {
    return Left("Terjadi kesalahan saat update status: $e");
  }
}


}
