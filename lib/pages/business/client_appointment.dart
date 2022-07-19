import 'dart:convert';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/widgets/Form/appointment_form.dart';
import 'package:openapp/widgets/hex_color.dart';
import 'package:openapp/utility/appurl.dart';

import '../../model/service.dart';
import '../../model/business.dart';
import '../../model/staff.dart';
import '../../utility/Network/network_connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ClientAppointment extends StatefulWidget {
  const ClientAppointment({
    Key? key,
  }) : super(key: key);

  @override
  State<ClientAppointment> createState() => _ClientAppointmentState();
}

class _ClientAppointmentState extends State<ClientAppointment> {
  Future getClientAppointments() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url =
            'http://rxfarm91.cse.buffalo.edu:5001/api/appointments?uId=${currentCustomer!.id}';
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          return parsedJson;
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

  Future<String> getAddress(lat, long) async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p =
          await placemarkFromCoordinates(double.parse(lat), double.parse(long));

      // Taking the most probable result
      Placemark place = p[0];

      // Structuring the address
      return "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
      return "{address unavailable}";
    }
  }

  Future<Service> getBusinessServicesById(serviceId) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.getBusinessServiceById(
          serviceId,
        );
        var response = await http.get(Uri.parse('$url'), headers: {
          'Authorization': 'Bearer ${currentCustomer?.token}',
        });

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);

          return Service.fromJson(parsedJson);
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

  Future<Staff> getBusinessStaffById(bId, staffId) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.getBusinessStaffByID(bId, staffId);
        var response = await http.get(
          Uri.parse('$url'),
          headers: {
            'Authorization': 'Bearer ${currentCustomer?.token}',
          },
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          return Staff.fromJson(parsedJson);
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

  Future<Business> getBusinessById(bId) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        // var body = {
        //   "bId": currentBusiness?.bId.toString(),
        //   "lat": _position?.latitude.toString(),
        //   "long": _position?.longitude.toString(),
        // };
        var startDate = DateTime.now();
        var timeUtc = startDate.toUtc();
        var url = 'http://rxfarm91.cse.buffalo.edu:5001/api/business/$bId}';
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business location');
          var parsedJson = json.decode(response.body);
          return Business.fromJson(parsedJson);
        } else {
          throw Exception('Failed to update business');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  Future<List<BusinessAppointment>> getClientAppointmentsInDetail() async {
    var appointments = await getClientAppointments();
    Map appointmentsBySlotId =
        appointments.groupListsBy((Map obj) => obj["slotId"]);
    List<BusinessAppointment> businessAppointments = [];
    for (var slotId in appointmentsBySlotId.keys) {
      var appointmentsInSlot = appointmentsBySlotId[slotId];
      var apointmentDetails = appointmentsInSlot.first;
      Business business = await getBusinessById(apointmentDetails["bId"]);
      Staff? staff = await getBusinessStaffById(
          apointmentDetails["bId"], apointmentDetails["staffId"]);
      Service service =
          await getBusinessServicesById(apointmentDetails["serviceId"]);
      businessAppointments.add(
        BusinessAppointment(
          slotId: slotId,
          appointments: appointmentsInSlot,
          slots: appointmentsInSlot.length,
          startDateTime: DateTime.parse(
              appointmentsInSlot.first["startDateTime"].toString()),
          endDateTime: DateTime.parse(
                  appointmentsInSlot.first["startDateTime"].toString())
              .add(
            Duration(
              minutes: service.time ?? 0,
            ),
          ),
          bName: business.bName,
          serviceName: service.serviceName,
          serviceCharge: service.cost.toString(),
          staffName: staff.firstName,
          address: await getAddress(business.lat, business.long),
        ),
      );
    }
    return businessAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                future: getClientAppointmentsInDetail(),
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
                                            'Services: ${appointment.serviceName}',
                                          ),
                                          Text(
                                            'Staff: ${appointment.staffName}',
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
