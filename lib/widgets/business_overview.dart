import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/model/shop.dart';
import 'package:openapp/widgets/hex_color.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/business.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../../pages/business/business_home.dart';

import 'package:http/http.dart' as http;

class BusinessOverview extends StatefulWidget {
  final Shop selectedBusiness;
  const BusinessOverview({Key? key, required this.selectedBusiness})
      : super(key: key);

  @override
  State<BusinessOverview> createState() => _BusinessOverviewState();
}

class _BusinessOverviewState extends State<BusinessOverview> {
  static const cleaningAndSanitization = [
    'Surfaces sanitized between seatings',
    'Common areas deep cleaned daily',
    'Sanitizer or wipes provided for customers',
    'Contactless payment available',
  ];
  static const staffScreening = [
    'Sick staff prohibited in the workplace',
    'Staff temperature check required',
    'Staff is vaccinated',
    'Waitstaff wear masks',
  ];

  var address;
  Widget _animatedOpenHours = Text(
    'Open Hours',
  );
  var dayData = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  var _daysOperating;
  // Future getBusinessHours() async {
  //   if (await CheckConnectivity.checkInternet()) {
  //     try {
  //       var url = AppConstant.getBusinesssHourById(widget.selectedBusiness.bId);
  //       var response = await http.get(Uri.parse('$url'), headers: {
  //         // 'Authorization': 'Bearer ${currentBusiness?.token}',
  //       });

  //       if (response.statusCode == 200) {
  //         //  json.decode(response.body);
  //         return json.decode(response.body);
  //       } else {
  //         throw Exception('Failed to fetch business hours');
  //       }
  //     } catch (e) {
  //       throw Exception('Failed to connect to server');
  //     }
  //   } else {
  //     throw Exception('Failed to connect to internet');
  //   }
  // }

  // Future<String> getOverviewDetails() async {
  //   _daysOperating = await getBusinessHours();
  //   if (_daysOperating == null || (_daysOperating as List).isEmpty) {
  //     _daysOperating = [
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //       {
  //         "day": 0,
  //         "startTime": "--:--",
  //         "endTime": "--:--",
  //         "isWorking": false
  //       },
  //     ];
  //   }
  //   address = widget.selectedBusiness.lat!.isEmpty
  //       ? 'business location not updated'
  //       : await _getAddress();
  //   return "done";
  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  // Future<String> _getAddress() async {
  //   try {
  //     // Places are retrieved using the coordinates
  //     List<Placemark> p = await placemarkFromCoordinates(
  //         double.parse(widget.selectedBusiness.lat!),
  //         double.parse(widget.selectedBusiness.long!));

  //     // Taking the most probable result
  //     Placemark place = p[0];

  //     // Structuring the address
  //     return "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
  //   } catch (e) {
  //     print(e);
  //     return "{address unavailable}";
  //   }
  // }

  Future<String> getOverviewDetails() async {
    return "true";
  }

  @override
  Widget build(BuildContext context) {
    Widget shopReviews = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '3.8',
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
            '\u2B50\u2B50\u2B50\u2B50\u2B50',
            style: TextStyle(
              fontSize: 14.0,
              color: HexColor('#757575'),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text.rich(
            TextSpan(
              text: '129 ',
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

    return FutureBuilder<String>(
        future: getOverviewDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      child: widget.selectedBusiness.images![0].isEmpty
                          ? Image.asset(
                              'assets/images/icons/open_app.png',
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: '${widget.selectedBusiness.images![0]}',
                              errorWidget: (context, error, errorDynamic) =>
                                  Image.asset(
                                      'assets/images/icons/open_app.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                //Name
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
                //Call
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: [
                      ActionChip(
                        backgroundColor: secondaryColor,
                        avatar: Icon(
                          Icons.call,
                          size: 16,
                          color: thirdColor,
                        ),
                        elevation: 3,
                        label: Text(
                          'Call',
                          style: TextStyle(
                            color: thirdColor,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          launchUrl(
                            Uri.parse(
                              "tel://${widget.selectedBusiness.phone}",
                            ),
                          );
                        },
                      ),
                      Spacer(),
                      ActionChip(
                        backgroundColor: secondaryColor,
                        onPressed: () {},
                        avatar: Icon(
                          Icons.directions,
                          size: 16,
                          color: thirdColor,
                        ),
                        label: Text(
                          'Directions',
                          style: TextStyle(
                            color: thirdColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Spacer(),
                      ActionChip(
                        backgroundColor: secondaryColor,
                        onPressed: () {
                          Share.share(
                              'check out openapp website http://openapponline.com/',
                              subject:
                                  'Reserve your favourite spot in an instance!');
                        },
                        avatar: Icon(
                          Icons.share,
                          size: 16,
                          color: thirdColor,
                        ),
                        label: Text(
                          'Share',
                          style: TextStyle(
                            color: thirdColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: secondaryColor,
                  ),
                  title: Text(
                      '${widget.selectedBusiness.location!.formattedAddress}'),
                ),

                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  leading: Icon(
                    Icons.description_rounded,
                    color: secondaryColor,
                  ),
                  title: Text(
                    '${widget.selectedBusiness.description ?? ""}',
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  onTap: () async {
                    await Future.delayed(
                      Duration(milliseconds: 100),
                    );
                    if (_animatedOpenHours is Text)
                      _animatedOpenHours = Column(
                        children: List.generate(7, (index) {
                          var dateToday = DateTime.now();
                          var currWeekNumber = dateToday.weekday;
                          var weekNumber = (index) + currWeekNumber;
                          if (weekNumber > 7) weekNumber = weekNumber - 7;
                          var startTime =
                              _daysOperating[weekNumber - 1]["startTime"];
                          var endTime =
                              _daysOperating[weekNumber - 1]["endTime"];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dayData[weekNumber]!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: currWeekNumber == weekNumber
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  '''${startTime ?? '--:--'} to ${endTime ?? '--:--'}''',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: currWeekNumber == weekNumber
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    else {
                      _animatedOpenHours = Text(
                        'Open Hours',
                      );
                    }
                    setState(() {});
                  },
                  leading: Icon(
                    Icons.watch_later_outlined,
                    color: secondaryColor,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 200,
                        ),
                        child: _animatedOpenHours,
                        transitionBuilder: (child, _animation) =>
                            ScaleTransition(
                          child: child,
                          scale: _animation,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  leading: Icon(
                    Icons.clean_hands_rounded,
                    color: secondaryColor,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cleaning & Sanitizing',
                        ),
                        Wrap(
                          spacing: 2,
                          children: cleaningAndSanitization
                              .map(
                                (item) => Chip(
                                  backgroundColor: thirdColor,
                                  avatar: Icon(
                                    Icons.check,
                                  ),
                                  label: Text(
                                    item,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  leading: Icon(
                    Icons.health_and_safety_outlined,
                    color: secondaryColor,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Staff Cleaning',
                        ),
                        Wrap(
                          spacing: 2,
                          children: staffScreening
                              .map(
                                (item) => Chip(
                                  backgroundColor: thirdColor,
                                  avatar: Icon(
                                    Icons.check,
                                  ),
                                  label: Text(
                                    item,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
