import 'dart:convert';

class RegisterRequestModel {
    final String? name;
    final String? username;
    final String? email;
    final String? phone;
    final String? password;
    final int? roleId;

    RegisterRequestModel({
        this.name,
        this.username,
        this.email,
        this.phone,
        this.password,
        this.roleId,
    });

    factory RegisterRequestModel.fromJson(String str) => RegisterRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterRequestModel.fromMap(Map<String, dynamic> json) => RegisterRequestModel(
        name: json["name"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        roleId: json["role_id"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
        "role_id": roleId,
    };
}
