import 'dart:convert';
import '../appurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openapp/utility/Network/network_connectivity.dart';

class NetworkHelper {
  static Future<dynamic> get(String url, {Map? params, Map? queries}) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var header = {'Content-Type': 'application/json'};
        var response = await http.get(
          Uri.parse('$url'),
          headers: header,
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception(
              '${response.statusCode} + ' ' +${response.reasonPhrase}');
        }
      } catch (e) {
        print(e);
        throw Exception('Failed to load business details');
      }
    }
  }

  static Future<dynamic> post(String url,
      {Map? params, Map? queries, Object? body}) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var header = {'content-type': 'application/json'};
        var response = await http.post(
          Uri.parse('$url'),
          body: body,
        );
        if (response.statusCode == 201) {
          return json.decode(response.body);
        } else {
          throw Exception(
              '${response.statusCode} + ' ' +${response.reasonPhrase}');
        }
      } catch (e) {
        print(e);
        throw Exception('Failed to load business details');
      }
    }
  }
}
