import 'dart:convert';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/widgets/Form/appointment_form.dart';
import 'package:openapp/pages/widgets/hex_color.dart';
import 'package:openapp/utility/appurl.dart';

import '../model/service.dart';
import '../model/business.dart';
import '../model/staff.dart';
import '../utility/Network/network_connectivity.dart';
import 'package:http/http.dart' as http;

class ClientAppointment extends StatefulWidget {
  final Business selectedBusiness;
  final List<Staff> staffList;
  final List<Service> serviceList;
  const ClientAppointment(
      {Key? key,
      required this.selectedBusiness,
      required this.staffList,
      required this.serviceList})
      : super(key: key);

  @override
  State<ClientAppointment> createState() => _ClientAppointmentState();
}

class _ClientAppointmentState extends State<ClientAppointment> {
  Future<List<BusinessAppointment>> getClientAppointmentDetails() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url =
            'http://rxfarm91.cse.buffalo.edu:5001/api/appointments?uId=${currentClient!.id}';
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          return parsedJson
              .map<BusinessAppointment>(
                  (json) => BusinessAppointment.fromJson(json))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentForm(
                  selectedBusiness: widget.selectedBusiness,
                  staffList: widget.staffList,
                  serviceList: widget.serviceList),
            ),
          );
        },
        backgroundColor: HexColor('#143F6B'),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Appointments',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Select a appointment to view details'),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<BusinessAppointment>>(
                future: getClientAppointmentDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var listOfAppointment = snapshot.data;

                      return listOfAppointment!.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/empty.svg',
                                    width: 150,
                                    height: 150,
                                  ),
                                  Text('No services found'),
                                ],
                              ),
                            )
                          : ListView(
                              children: [
                                ...listOfAppointment.map<Widget>((appointment) {
                                  var staff = widget.staffList[0];
                                  var service = widget.serviceList[0];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: ListTile(
                                      leading: SvgPicture.asset(
                                        'assets/images/icons/appointment.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${appointment.firstName} ${appointment.lastName}'),
                                          Text(
                                            'Services: ${service.serviceName}',
                                          ),
                                          Text(
                                            'Staff: ${staff.firstName}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/error.svg',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              'There seems to be Issue while fetching services from server'),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(secondaryColor),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    50,
                                  ),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Reload',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {});
                            },
                          ),

                          // Text(snapshot.error.toString()),
                        ],
                      ));
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
