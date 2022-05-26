import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:openapp/model/service.dart';
import 'package:openapp/pages/client_appointment.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/widgets/staff.dart';
import 'package:openapp/pages/widgets/business_overview.dart';
import 'package:openapp/pages/widgets/services.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../model/business.dart';
import '../model/staff.dart';
import '../utility/Network/network_connectivity.dart';
import '../utility/appurl.dart';
import 'package:http/http.dart' as http;

class BusinessDetail extends StatefulWidget {
  final Business selectedBusiness;
  const BusinessDetail({Key? key, required this.selectedBusiness})
      : super(key: key);

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  List<Service> services = [];
  List<Staff> staff = [];
  Future<List<Service>> getBusinessServices() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.getBusinessService(
          widget.selectedBusiness.bId,
        );
        var response = await http.get(Uri.parse('$url'), headers: {
          'Authorization': 'Bearer ${currentClient?.token}',
        });

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          widget.selectedBusiness.services = parsedJson
              .map<Service>((json) => Service.fromJson(json))
              .toList();
          return parsedJson
              .map<Service>((json) => Service.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to fetch business services');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to internet');
    }
  }

  Future<List<Staff>> getBusinessStaff() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.getBusinessStaff(
          widget.selectedBusiness.bId,
        );
        var response = await http.get(
          Uri.parse('$url'),
          headers: {
            'Authorization': 'Bearer ${currentClient?.token}',
          },
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          widget.selectedBusiness.staff =
              parsedJson.map<Staff>((json) => Staff.fromJson(json)).toList();
          return parsedJson.map<Staff>((json) => Staff.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch business staff');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to internet');
    }
  }

  Future<String> getBusinessServiceStaffDetails() async {
    services = await getBusinessServices();
    staff = await getBusinessStaff();
    return "done";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Business Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: getBusinessServiceStaffDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    indicatorColor: Theme.of(context).secondaryHeaderColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 5.0,
                    labelColor: Colors.black,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Appointments'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        BusinessOverview(
                          selectedBusiness: widget.selectedBusiness,
                        ),
                        ClientAppointment(
                            selectedBusiness: widget.selectedBusiness,
                            staffList: staff,
                            serviceList: services),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}

class BusinessHeader extends StatelessWidget {
  const BusinessHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          child: Text('Business Details'),
        ),
      ],
    );
  }
}
