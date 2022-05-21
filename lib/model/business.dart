import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openapp/utility/appurl.dart';

class Business extends ChangeNotifier {
  late String? name;
  late String? description;
  late String? address;
  late String? phone;
  late String? email;
  late String? businessCity;
  late String? businessState;
  late String? businessZip;
  late String? businessCategory;
  late var businessServices;
  late var businessAppointments;
  late var businessStaffs;

  Business.create();

  Business({
    this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.businessCity,
    this.businessState,
    this.businessZip,
    this.businessCategory,
    this.businessAppointments,
    this.businessServices,
    this.businessStaffs,
  });

  void copyFrom(Business business) {
    this.name = business.name;
    this.description = business.description;
    this.address = business.address;
    this.phone = business.phone;
    this.email = business.email;
    this.businessCity = business.businessCity;
    this.businessState = business.businessState;
    this.businessZip = business.businessZip;
    this.businessCategory = business.businessCategory;
    this.businessAppointments = business.businessAppointments;
    this.businessServices = business.businessServices;
    this.businessStaffs = business.businessStaffs;
  }

  Business copyWith({
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? businessCity,
    String? businessState,
    String? businessZip,
    String? businessCategory,
    List? businessAppointments,
    List? businessServices,
    List? businessStaffs,
  }) {
    return Business(
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      businessCity: businessCity ?? this.businessCity,
      businessState: businessState ?? this.businessState,
      businessZip: businessZip ?? this.businessZip,
      businessCategory: businessCategory ?? this.businessCategory,
      businessAppointments: businessAppointments ?? this.businessAppointments,
      businessServices: businessServices ?? this.businessServices,
      businessStaffs: businessStaffs ?? this.businessStaffs,
    );
  }

  StreamController<Business> _streamController = StreamController.broadcast();
  Stream<Business> get businessStream => _streamController.stream;
  get businessStreamController => _streamController;

  Future<Business> getBusinessDetails() async {
    // return await Future.delayed(Duration(seconds: 2), () {
    return this.copyWith(
      name: 'Business Name',
      description: 'Business Description',
      address: 'Business Address',
      phone: 'Business Phone',
      email: 'Business Email',
      businessCity: 'Business City',
      businessState: 'Business State',
      businessZip: 'Business Zip',
      businessCategory: 'Business Category',
      businessServices: [],
      businessAppointments: [],
      businessStaffs: [],
    );
    // });
  }

  Future<Business> getBusinessServices() async {
    // return await Future.delayed(
    //   Duration(seconds: 2),
    //   () async {
    return this.copyWith(
      businessServices: [
        {
          'serviceName': 'Service Name',
          'serviceDescription': 'Service Description',
          'servicePrice': 'Service Price',
          'serviceDuration': 'Service Duration',
          'serviceImage': 'Service Image',
        },
      ],
    );
    //   },
    // );
    // try {
    //   final response = await http.get(
    //     Uri.parse(
    //       '${AppConstant.BASE_URL}${AppConstant.GET_BUSINESS_SERVICES}',
    //     ),
    //   );
    //   if (response.statusCode == 200) {
    //     final jsonResponse = json.decode(response.body);
    //     return Business.fromJson(jsonResponse);
    //   } else {
    //     throw Exception('Failed to load business details');
    //   }
    // } catch (e) {
    //   throw Exception('Failed to load business details');
    // }
  }

  Future<Business> getBusinessAppointments() async {
    // return await Future.delayed(Duration(seconds: 2), () {
    return this.copyWith(
      businessAppointments: [
        {
          'id': '1',
          'title': 'Appointment 1',
          'start': '2020-01-01',
          'end': '2020-01-01',
          'color': '#00bcd4',
        }
      ],
    );
    // });

    // try {
    //   final response = await http.get(
    //     Uri.parse(
    //         '${AppConstant.BASE_URL}${AppConstant.GET_BUSINESS_APPOINTMENT}'),
    //   );
    //   if (response.statusCode == 200) {
    //     final jsonResponse = json.decode(response.body);
    //     return Business.fromJson(jsonResponse);
    //   } else {
    //     throw Exception('Failed to load business details');
    //   }
    // } catch (e) {
    //   throw Exception('Failed to load business details');
    // }
  }

  Future<Business> getBusinessStaffs() async {
    // return await Future.delayed(Duration(seconds: 2), () {
    return this.copyWith(
      businessStaffs: [
        {
          'id': '1',
          'name': 'Staff Name',
          'email': 'Staff Email',
          'phone': 'Staff Phone',
          'image': 'Staff Image',
        }
      ],
    );
    // });

    // try {
    //   final response = await http.get(
    //     Uri.parse('${AppConstant.BASE_URL}${AppConstant.GET_BUSINESS_STAFF}'),
    //   );
    //   if (response.statusCode == 200) {
    //     final jsonResponse = json.decode(response.body);
    //     return Business.fromJson(jsonResponse);
    //   } else {
    //     throw Exception('Failed to load business details');
    //   }
    // } catch (e) {
    //   throw Exception('Failed to load business details');
    // }
  }

  Future<void> createBusiness() async {
    // var response = await http
    //     .post(
    //   Uri.parse('${AppConstant.BASE_URL}${AppConstant.BUSINESS_SIGNUP}'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: json.encode({
    //     'name': this.name,
    //     'description': this.description,
    //     'address': this.address,
    //     'phone': this.phone,
    //     'email': this.email,
    //     'businessCity': this.businessCity,
    //     'businessState': this.businessState,
    //     'businessZip': this.businessZip,
    //     'businessCategory': this.businessCategory,
    //   }),
    // )
    //     .timeout(
    //         Duration(
    //           seconds: 10,
    //         ), onTimeout: () {
    //   throw Exception('Timeout');
    // });

    // if (response.statusCode == 200) {
    //   print(response.body);
    // } else {
    //   print(response.reasonPhrase);
    // }
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      businessCity: json['businessCity'],
      businessState: json['businessState'],
      businessZip: json['businessZip'],
      businessCategory: json['businessCategory'],
    );
  }
}
