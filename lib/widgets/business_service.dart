import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/widgets/ticket_view.dart';

import '../../constant.dart';
import '../../model/service.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../../pages/business/business_home.dart';

import '../model/shop.dart';
import 'form/service_form.dart';
import 'hex_color.dart';
import 'package:http/http.dart' as http;

class BusinessService extends StatefulWidget {
  final Shop? selectedBusiness;
  const BusinessService({Key? key, this.selectedBusiness}) : super(key: key);

  @override
  State<BusinessService> createState() => _BusinessServiceState();
}

class _BusinessServiceState extends State<BusinessService> {
  Future<List<Service>> getBusinessServices() async {
    String? businessId = widget.selectedBusiness?.id ?? '';

    if (await CheckConnectivity.checkInternet()) {
      try {
        String url = AppConstant.getBusinessService(businessId);
        var request = http.Request(
          'GET',
          Uri.parse(url),
        );
        request.bodyFields = {};

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var parsedJson = json.decode(await response.stream.bytesToString());
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
              'Business Services',
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var listOfServices = snapshot.data;
                      return listOfServices!.isEmpty
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
                                ...listOfServices.map<Widget>(
                                  (service) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: ListTile(
                                      key: Key(service.name!),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        child: service.images![0].isEmpty
                                            ? Image.asset(
                                                'assets/images/icons/open_app.png',
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                width: 100,
                                                height: 100,
                                                imageUrl:
                                                    '${service.images![0]}',
                                                errorWidget: (context, error,
                                                        errorDynamic) =>
                                                    Image.asset(
                                                        'assets/images/icons/open_app.png'),
                                                fit: BoxFit.cover,
                                              ),
                                      ),

                                      title: Text(
                                        service.name.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ServiceForm(
                                            selectedService: service,
                                            isEditable: false,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        service.description.toString(),
                                        strutStyle: StrutStyle(
                                          fontSize: 20,
                                        ),
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      trailing: Text(
                                        '\$ ${service.price.toString()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // image: 'assets/images/service1.png',
                                    ),
                                  ),
                                ),
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
