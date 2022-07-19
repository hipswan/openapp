// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

class Customer {
  Customer({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.role,
    this.businessRequested,
    this.token,
  });

  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? role;
  final bool? businessRequested;
  final String? token;

  Customer copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? role,
    bool? businessRequested,
    String? token,
  }) =>
      Customer(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        role: role ?? this.role,
        businessRequested: businessRequested ?? this.businessRequested,
        token: token ?? this.token,
      );

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["user"]["id"],
        firstname: json["user"]["firstname"],
        lastname: json["user"]["lastname"],
        email: json["user"]["email"],
        role: json["user"]["role"],
        businessRequested: json["user"]["businessRequested"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "role": role,
        "businessRequested": businessRequested,
        "token": token,
      };
}
