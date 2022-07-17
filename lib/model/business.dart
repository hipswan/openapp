import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:openapp/model/service.dart';
import 'package:openapp/model/staff.dart';
import 'package:openapp/utility/Network/network_connectivity.dart';
import 'package:openapp/utility/Network/network_helper.dart';
import 'package:openapp/utility/appurl.dart';

// To parse this JSON data, do
//
//     final business = businessFromJson(jsonString);

import 'dart:convert';

class Business {
  Business({
    this.token,
    this.id,
    this.emailId,
    this.firstName,
    this.lastName,
    this.bId,
    this.uId,
    this.bName,
    this.bCity,
    this.bZip,
    this.bState,
    this.bType,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.lat,
    this.long,
    this.extraData3,
    this.appointments,
    this.staff,
  });

  String? token;
  int? id;
  String? emailId;
  String? firstName;
  String? lastName;
  int? bId;
  int? uId;
  String? bName;
  String? bCity;
  String? bZip;
  String? bState;
  String? bType;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? lat;
  String? long;
  String? extraData3;
  List<BusinessAppointment>? appointments;
  List<Staff>? staff;
  List<Service>? services;
  StreamController<Business> _streamController = StreamController.broadcast();
  Stream<Business> get businessStream => _streamController.stream;
  get businessStreamController => _streamController;

  Business copyWith({
    String? token,
    int? id,
    String? emailId,
    String? firstName,
    String? lastName,
    int? bId,
    int? uId,
    String? bName,
    String? bCity,
    String? bZip,
    String? bState,
    String? bType,
    String? description,
    String? image1,
    String? image2,
    String? image3,
    String? lat,
    String? long,
    String? extraData3,
  }) =>
      Business(
        token: token ?? this.token,
        id: id ?? this.id,
        emailId: emailId ?? this.emailId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        bId: bId ?? this.bId,
        uId: uId ?? this.uId,
        bName: bName ?? this.bName,
        bCity: bCity ?? this.bCity,
        bZip: bZip ?? this.bZip,
        bState: bState ?? this.bState,
        bType: bType ?? this.bType,
        description: description ?? this.description,
        image1: image1 ?? this.image1,
        image2: image2 ?? this.image2,
        image3: image3 ?? this.image3,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        extraData3: extraData3 ?? this.extraData3,
      );

  factory Business.fromRawJson(String str) =>
      Business.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  fromSignIn(Map<String, dynamic> json) {
    this.token = json["token"];
    this.id = json["id"];
    this.emailId = json["emailId"];
    this.firstName = json["firstName"];
    this.lastName = json["lastName"];
    this.bId = json["bId"];
    this.uId = json["uId"];
    this.bName = json["bName"];
    this.bCity = json["bCity"];
    this.bZip = json["bZip"];
    this.bState = json["bState"];
    this.bType = json["bType"];
    this.description = json["description"];
    this.image1 = json["image1"];
    this.image2 = json["image2"];
    this.image3 = json["image3"];
    this.lat = json["lat"];
    this.long = json["long"];
    this.extraData3 = json["extraData3"];
  }

  saveAppointments(appointments) {
    this.appointments = appointments
        .map<BusinessAppointment>((e) => BusinessAppointment.fromJson(e))
        .toList();
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      token: json["token"],
      id: json["id"],
      emailId: json["emailId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      bId: json["bId"],
      uId: json["uId"],
      bName: json["bName"],
      bCity: json["bCity"],
      bZip: json["bZip"],
      bState: json["bState"],
      bType: json["bType"],
      description: json["description"],
      image1: json["image1"],
      image2: json["image2"],
      image3: json["image3"],
      lat: json["lat"],
      long: json["long"],
      extraData3: json["extraData3"],
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "emailId": emailId,
        "firstName": firstName,
        "lastName": lastName,
        "bId": bId,
        "uId": uId,
        "bName": bName,
        "bCity": bCity,
        "bZip": bZip,
        "bState": bState,
        "bType": bType,
        "description": description,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "lat": lat,
        "long": long,
        "extraData3": extraData3,
      };
}

// To parse this JSON data, do
//
//     final appointment = appointmentFromJson(jsonString);

// To parse this JSON data, do
//
//     final businessAppointment = businessAppointmentFromJson(jsonString);

class BusinessAppointment {
  BusinessAppointment({
    this.slotId,
    this.appointments,
    this.slots,
    this.startDateTime,
    this.endDateTime,
    this.bName,
    this.serviceName,
    this.serviceCharge,
    this.staffName,
    this.address,
    this.notes,
    this.emailId,
    this.firstName,
    this.lastName,
    this.staffId,
  });

  final String? slotId;
  final String? appointments;
  final String? slots;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? bName;
  final String? serviceName;
  final String? serviceCharge;
  final String? staffName;
  final String? address;
  final String? notes;
  final String? emailId;
  final String? firstName;
  final String? lastName;
  final String? staffId;

  BusinessAppointment copyWith({
    String? slotId,
    String? appointments,
    String? slots,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? bName,
    String? serviceName,
    String? serviceCharge,
    String? staffName,
    String? address,
    String? notes,
    String? emailId,
    String? firstName,
    String? lastName,
    String? staffId,
  }) =>
      BusinessAppointment(
        slotId: slotId ?? this.slotId,
        appointments: appointments ?? this.appointments,
        slots: slots ?? this.slots,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        bName: bName ?? this.bName,
        serviceName: serviceName ?? this.serviceName,
        serviceCharge: serviceCharge ?? this.serviceCharge,
        staffName: staffName ?? this.staffName,
        address: address ?? this.address,
        notes: notes ?? this.notes,
        emailId: emailId ?? this.emailId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        staffId: staffId ?? this.staffId,
      );

  factory BusinessAppointment.fromRawJson(String str) =>
      BusinessAppointment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessAppointment.fromJson(Map<String, dynamic> json) =>
      BusinessAppointment(
        slotId: json["slotId"],
        appointments: json["appointments"],
        slots: json["slots"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
        bName: json["bName"],
        serviceName: json["serviceName"],
        serviceCharge: json["serviceCharge"],
        staffName: json["staffName"],
        address: json["address"],
        notes: json["notes"],
        emailId: json["emailId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        staffId: json["staffId"],
      );

  Map<String, dynamic> toJson() => {
        "slotId": slotId,
        "appointments": appointments,
        "slots": slots,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "bName": bName,
        "serviceName": serviceName,
        "serviceCharge": serviceCharge,
        "staffName": staffName,
        "address": address,
        "notes": notes,
        "emailId": emailId,
        "firstName": firstName,
        "lastName": lastName,
        "staffId": staffId,
      };
}
