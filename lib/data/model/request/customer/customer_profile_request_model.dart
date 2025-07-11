import 'dart:convert';

class CustomerProfileRequestModel {
    final String? name;
    final String? username;
    final String? email;
    final String? phone;
    final String? password;
    final String? address;
    final int? latitude;
    final int? longitude;
    final String? passwordConfirmation;

    CustomerProfileRequestModel({
        this.name,
        this.username,
        this.email,
        this.phone,
        this.password,
        this.address,
        this.latitude,
        this.longitude,
        this.passwordConfirmation,
    });

    factory CustomerProfileRequestModel.fromJson(String str) => CustomerProfileRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerProfileRequestModel.fromMap(Map<String, dynamic> json) => CustomerProfileRequestModel(
        name: json["name"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        passwordConfirmation: json["password_confirmation"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "password_confirmation": passwordConfirmation,
    };
}
