import 'dart:convert';
import 'dart:developer';

import 'package:galongo/data/model/request/customer/customer_profile_request_model.dart';
import 'package:galongo/data/model/response/customer/customer_profile_response_model.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileCustomerRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  ProfileCustomerRepository(this._serviceHttpClient);

  // Tambah atau update profil customer
  Future<Either<String, CustomerProfileResponseModel>> addOrUpdateProfile(
    CustomerProfileRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        'customer/profile',
        requestModel.toMap(),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final profileResponse = CustomerProfileResponseModel.fromMap(jsonResponse);
        log(" Customer Profile saved: ${profileResponse.message}");
        return Right(profileResponse);
      } else {
        log(" Save Customer Profile failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Failed to save customer profile");
      }
    } catch (e) {
      log(" Error saving customer profile: $e");
      return Left("An error occurred: $e");
    }
  }

  // Ambil profil customer
  Future<Either<String, CustomerProfileResponseModel>> getProfile() async {
    try {
      final response = await _serviceHttpClient.getWithToken("customer/profile");

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final profileResponse = CustomerProfileResponseModel.fromMap(jsonResponse);
        log(" Get Customer Profile success: ${profileResponse.message}");
        return Right(profileResponse);
      } else {
        log(" Get Customer Profile failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Failed to get customer profile");
      }
    } catch (e) {
      log(" Error getting customer profile: $e");
      return Left("An error occurred: $e");
    }
  }
}
