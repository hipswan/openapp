import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/model/service.dart';
import 'package:openapp/model/shop.dart';
import 'package:openapp/widgets/business_location.dart';
import 'package:openapp/widgets/form/appointment_form.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/Form/info_form.dart';
import '../../widgets/business_service.dart';
import '../../widgets/hex_color.dart';
import './client_appointment.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/widgets/staff.dart';
import 'package:openapp/widgets/business_overview.dart';
import 'package:openapp/widgets/services.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../model/business.dart';
import '../../model/staff.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import 'package:http/http.dart' as http;

class BusinessDetail extends StatefulWidget {
  final Shop selectedBusiness;
  const BusinessDetail({Key? key, required this.selectedBusiness})
      : super(key: key);

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  List<Service> services = [];
  List<Staff> staff = [];
  // Future<List<Service>> getBusinessServices() async {
  //   if (await CheckConnectivity.checkInternet()) {
  //     try {
  //       var url = AppConstant.getBusinessService(
  //         widget.selectedBusiness.bId,
  //       );
  //       var response = await http.get(Uri.parse('$url'), headers: {
  //         'Authorization': 'Bearer ${currentCustomer?.token}',
  //       });

  //       if (response.statusCode == 200) {
  //         //  json.decode(response.body);
  //         var parsedJson = json.decode(response.body);
  //         widget.selectedBusiness.services = parsedJson
  //             .map<Service>((json) => Service.fromJson(json))
  //             .toList();
  //         return widget.selectedBusiness.services ?? [];
  //       } else {
  //         throw Exception('Failed to fetch business services');
  //       }
  //     } catch (e) {
  //       throw Exception('Failed to connect to server');
  //     }
  //   } else {
  //     throw Exception('Failed to connect to internet');
  //   }
  // }

  // Future<List<Staff>> getBusinessStaff() async {
  //   if (await CheckConnectivity.checkInternet()) {
  //     try {
  //       var url = AppConstant.getBusinessStaff(
  //         widget.selectedBusiness.bId,
  //       );
  //       var response = await http.get(
  //         Uri.parse('$url'),
  //         headers: {
  //           'Authorization': 'Bearer ${currentCustomer?.token}',
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         //  json.decode(response.body);
  //         var parsedJson = json.decode(response.body);
  //         widget.selectedBusiness.staff =
  //             parsedJson.map<Staff>((json) => Staff.fromJson(json)).toList();
  //         return widget.selectedBusiness.staff ?? [];
  //       } else {
  //         throw Exception('Failed to fetch business staff');
  //       }
  //     } catch (e) {
  //       throw Exception('Failed to connect to server');
  //     }
  //   } else {
  //     throw Exception('Failed to connect to internet');
  //   }
  // }

  // Future<String> getBusinessServiceStaffDetails() async {
  //   services = await getBusinessServices();
  //   staff = await getBusinessStaff();
  //   return "done";
  // }

  @override
  Widget build(BuildContext context) {
    Widget shopReviews = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '${widget.selectedBusiness.rating}',
            style: TextStyle(
              fontSize: 14.0,
              color: HexColor(
                '#757575',
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            String.fromCharCodes(
              List<int>.generate(
                5,
                (index) {
                  if (index < widget.selectedBusiness.rating!)
                    return 0x2605;
                  else
                    return 0x2606;
                },
              ),
            ),
            style: TextStyle(
              fontSize: 18.0,
              color: HexColor('#EEAB15'),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text.rich(
            TextSpan(
              text: '${widget.selectedBusiness.reviews!.length} ',
              style: TextStyle(
                color: HexColor('#3980EA'),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'reviews ',
                  style: TextStyle(
                    color: HexColor('#3980EA'),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            strutStyle: const StrutStyle(
              fontFamily: 'Serif',
              fontSize: 18,
              forceStrutHeight: true,
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'create_appoitnment',
          backgroundColor: secondaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (AppointmentForm(
                  selectedBusiness: widget.selectedBusiness,
                )),
              ),
            );
          },
          child: Icon(
            Icons.playlist_add,
            color: thirdColor,
          ),
        ),
        appBar: AppBar(
          title: Text('Business Details'),
          centerTitle: true,
        ),
        body: DefaultTabController(
          length: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: widget.selectedBusiness.images![0].isEmpty
                        ? Image.asset(
                            'assets/images/icons/open_app.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            height: 150,
                            width: 250,
                            imageUrl: '${widget.selectedBusiness.images![0]}',
                            errorWidget: (context, error, errorDynamic) =>
                                Image.asset('assets/images/icons/open_app.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  widget.selectedBusiness.name ?? "",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Name
                        shopReviews,
                        //Type
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            '${widget.selectedBusiness.category ?? ""}',
                            strutStyle: StrutStyle(
                              fontSize: 20,
                            ),
                            style: TextStyle(
                              color: HexColor('#757575'),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //Open or Close Indicator
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            'Closes 7pm',
                            strutStyle: StrutStyle(
                              fontSize: 20,
                            ),
                            style: TextStyle(
                              color: HexColor('#757575'),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InteractionButton(
                            icon: Icons.call,
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                  "tel://${widget.selectedBusiness.phone}",
                                ),
                              );
                            },
                          ),
                          InteractionButton(
                            icon: Icons.directions,
                            onPressed: () {},
                          ),
                          InteractionButton(
                            icon: Icons.share,
                            onPressed: () {
                              Share.share(
                                  'check out openapp website http://openapponline.com/',
                                  subject:
                                      'Reserve your favourite spot in an instance!');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      Tab(
                        text: 'Overview',
                      ),
                      Tab(
                        text: 'Services',
                      ),
                      Tab(
                        text: 'Location',
                      ),
                      Tab(
                        text: 'Reviews',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    BusinessOverview(
                      selectedBusiness: widget.selectedBusiness,
                    ),
                    BusinessService(
                      selectedBusiness: widget.selectedBusiness,
                    ),
                    BusinessLocation(
                      selectedBusiness: widget.selectedBusiness,
                    ),
                    //TODO: Add Reviews
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final onPressed;
  const InteractionButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(
          14.0,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: secondaryColor,
        ),
        child: Icon(
          icon,
          size: 18,
          color: thirdColor,
        ),
      ),
    );
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
