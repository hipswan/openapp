import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openapp/constant.dart';
import 'package:share_plus/share_plus.dart';

import '../../model/business.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../../pages/business/business_home.dart';

import 'package:http/http.dart' as http;

class BusinessOverview extends StatefulWidget {
  final Business selectedBusiness;
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
  Future getBusinessHours() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.getBusinesssHourById(widget.selectedBusiness.bId);
        var response = await http.get(Uri.parse('$url'), headers: {
          // 'Authorization': 'Bearer ${currentBusiness?.token}',
        });

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          return json.decode(response.body);
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

  Future<String> getOverviewDetails() async {
    _daysOperating = await getBusinessHours();
    address = widget.selectedBusiness.lat!.isEmpty
        ? 'business location not updated'
        : await _getAddress();
    return "done";
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Future<String> _getAddress() async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await placemarkFromCoordinates(
          double.parse(widget.selectedBusiness.lat!),
          double.parse(widget.selectedBusiness.long!));

      // Taking the most probable result
      Placemark place = p[0];

      // Structuring the address
      return "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
      return "{address unavailable}";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    '${widget.selectedBusiness.bName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: SizedBox(
                    height: 150,
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      scrollDirection: Axis.horizontal,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          child: Container(
                            width: 150,
                            color: secondaryColor,
                            child: widget.selectedBusiness.image1!.isEmpty
                                ? FlutterLogo()
                                : CachedNetworkImage(
                                    imageUrl:
                                        '${AppConstant.PICTURE_ASSET_PATH}/${widget.selectedBusiness.image1}',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    '${widget.selectedBusiness.bType}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    '${widget.selectedBusiness.bCity} , ${widget.selectedBusiness.bState}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    'Open: Closes 7pm',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: Icon(
                          Icons.call,
                        ),
                        label: Text(
                          'Call',
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ActionChip(
                        onPressed: () {},
                        avatar: Icon(
                          Icons.directions,
                        ),
                        label: Text(
                          'Directions',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ActionChip(
                        onPressed: () {
                          Share.share(
                              'check out my website https://openapp.com',
                              subject: 'Look what I made!');
                        },
                        avatar: Icon(
                          Icons.share,
                        ),
                        label: Text(
                          'Share',
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
                  title: Text('$address'),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 100));
                    setState(() {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    '''${startTime} - ${endTime}''',
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
                    });
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
