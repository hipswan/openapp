import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:openapp/pages/widgets/ticket_view.dart';

import '../../model/Service.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../business_home.dart';
import 'Form/service_form.dart';
import 'hex_color.dart';
import 'package:http/http.dart' as http;

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  var _services = [
    {
      'name': 'Service 1',
      'description': 'Description of Service 1',
      'price': '\$10',
      'image': 'assets/images/service1.png',
    },
    {
      'name': 'Service 2',
      'description': 'Description of Service 2',
      'price': '\$20',
      'image': 'assets/images/service2.png',
    }
  ];

  Future<List<Service>> getBusinessServices() async {
    if (currentBusiness!.services!.length > 0) {
      return currentBusiness!.services!;
    }

    if (await CheckConnectivity.checkInternet()) {
      try {
        var response = await http.get(
          Uri.parse('${AppConstant.getBusinesssHourById(
            currentBusiness?.bId,
          )})'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          currentBusiness!.services = parsedJson
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

  Future deleteBusinessService(serviceId) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var response = await http.delete(
          Uri.parse('${AppConstant.getBusinessService(
            currentBusiness?.bId,
          )})'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          // var parsedJson = json.decode(response.body);
          // return parsedJson
          //     .map<Service>((json) => Service.fromJson(json))
          //     .toList();
          currentBusiness!.services = currentBusiness!.services
              ?.where((service) => service.id != serviceId)
              .toList();
        } else {
          throw Exception('Failed to fetch business hours');
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
              builder: (context) => ServiceForm(),
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
              'Business Info',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Select a service to view its details'),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<Service>>(
                future: getBusinessServices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        ...snapshot.data!.map<Widget>(
                          (service) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: TicketView(
                              key: Key(service.serviceName!),
                              serviceName: service.serviceName,
                              serviceDescription: service.desc,
                              servicePrice: service.cost,
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceForm(selectedService: service),
                                  ),
                                );
                              },
                              onDelete: () async {
                                await deleteBusinessService(service.id);
                                setState(() {});
                                // setState(() {
                                //   snapshot.data!.remove(service);
                                // });
                              },

                              // image: 'assets/images/service1.png',
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
