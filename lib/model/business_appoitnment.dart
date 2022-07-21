// To parse this JSON data, do
//
//     final businessAppoitment = businessAppoitmentFromJson(jsonString);

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:openapp/model/business.dart';
import 'package:openapp/model/service.dart';
import 'package:openapp/model/shop.dart';

class BusinessAppointment {
  BusinessAppointment({
    this.id,
    this.startTime,
    this.endTime,
    this.business,
    this.service,
    this.user,
    this.note,
    this.v,
  });

  final String? id;
  final DateTime? startTime;
  final DateTime? endTime;
  final Shop? business;
  final Service? service;
  final String? user;
  final int? v;
  final String? note;

  BusinessAppointment copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    Shop? business,
    Service? service,
    String? user,
    String? note,
    int? v,
  }) =>
      BusinessAppointment(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        business: business ?? this.business,
        service: service ?? this.service,
        user: user ?? this.user,
        note: note ?? this.note,
        v: v ?? this.v,
      );

  factory BusinessAppointment.fromRawJson(String str) =>
      BusinessAppointment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessAppointment.fromJson(Map<String, dynamic> json) =>
      BusinessAppointment(
        id: json["_id"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        business: Shop.fromJson(json["business"]),
        service: Service.fromJson(json["service"]),
        user: json["user"],
        note: json["note"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "startTime": startTime?.toIso8601String() ?? "",
        "endTime": endTime?.toIso8601String() ?? "",
        "business": business?.toJson() ?? "",
        "service": service?.toJson() ?? "",
        "user": user,
        "note": note,
        "__v": v,
      };
}
