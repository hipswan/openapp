import 'dart:convert';
import '../appurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openapp/utility/Network/network_connectivity.dart';

class NetworkHelper {
  static Future<dynamic> request(String url, String method, Object body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      method,
      Uri.parse('${AppConstant.BASE_URL}${AppConstant.BUSINESS_SIGNUP}'),
    );
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
