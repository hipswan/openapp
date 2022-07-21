import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/widgets/Form/info_form.dart';
import 'package:openapp/widgets/business_location.dart';
import 'package:openapp/widgets/business_service.dart';
import 'package:openapp/widgets/hex_color.dart';
import 'package:openapp/widgets/info_wall.dart';
import 'package:openapp/widgets/services.dart';
import 'package:openapp/widgets/staff.dart';

import '../../model/shop.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../../widgets/form/business_form.dart';
import 'business_details.dart';
import 'business_home.dart';
import 'package:http/http.dart' as http;

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  Future<Shop> getBusinessDetail() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        String url = AppConstant.CUSTOMER_BUSINESS;
        var request = http.Request(
          'GET',
          Uri.parse(url),
        );
        request.headers.addAll(<String, String>{
          'x-auth-token': '${currentCustomer?.token}',
        });
        request.bodyFields = {};

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var parsedJson = json.decode(await response.stream.bytesToString());
          return Shop.fromJson(parsedJson[0]);
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
    Widget businessMetaData(Shop? business) => ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ),
            child: business!.images![0].isEmpty
                ? Image.asset(
                    'assets/images/icons/open_app.png',
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    width: 100,
                    height: 100,
                    imageUrl: '${business.images![0]}',
                    errorWidget: (context, error, errorDynamic) =>
                        Image.asset('assets/images/icons/open_app.png'),
                    fit: BoxFit.cover,
                  ),
          ),

          title: Text(
            business.name.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Text(
            business.description.toString(),
            strutStyle: StrutStyle(
              fontSize: 20,
            ),
            maxLines: 2,
            style: TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: InteractionButton(
            icon: Icons.edit,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusinessForm(
                    selectedBusiness: business,
                  ),
                ),
              );
            },
          ),
          // image: 'assets/images/service1.png',
        );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Profile'),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: FutureBuilder<Shop>(
            future: getBusinessDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Shop? currentBusiness = snapshot.data;
                return DefaultTabController(
                  length: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: businessMetaData(currentBusiness),
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Material(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          child: TabBar(
                            isScrollable: false,
                            indicatorColor:
                                Theme.of(context).secondaryHeaderColor,
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
                              Tab(
                                text: 'Info',
                              ),
                              Tab(
                                text: 'Services',
                              ),
                              Tab(
                                text: 'Staff',
                              ),
                              Tab(
                                text: 'Location',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            //TODO: Add Business Hours Wall
                            Builder(
                              builder: (context) => InfoWall(
                                selectedBusiness: currentBusiness,
                              ),
                            ),
                            Builder(
                              builder: (context) => BusinessService(
                                selectedBusiness: currentBusiness,
                              ),
                            ),
                            Builder(
                              builder: (context) => Staffs(
                                selectedBusiness: currentBusiness,
                              ),
                            ),
                            Builder(
                              builder: (context) => BusinessLocation(
                                selectedBusiness: currentBusiness,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
