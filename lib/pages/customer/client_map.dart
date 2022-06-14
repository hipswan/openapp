import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../business/business_details.dart';
import 'package:openapp/widgets/filter_search.dart';
import 'package:openapp/widgets/more_filter.dart';
import 'package:openapp/utility/appurl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:developer' as dev;
import '../../constant.dart';
import 'package:share_plus/share_plus.dart';

import '../../model/business.dart';
import '../../utility/Network/network_connectivity.dart';
import 'package:http/http.dart' as http;

class ClientMap extends StatefulWidget {
  @override
  State<ClientMap> createState() => ClientMapState();
}

class ClientMapState extends State<ClientMap> {
  Completer<GoogleMapController> _controller = Completer();
  // For storing the current position
  Position? _currentPosition;
  PageController _pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 0.85,
  );

  var businessCategory = [
    'Restaurant',
    'Cafe',
  ];

  TextEditingController startAddressController = TextEditingController();
  // Object for PolylinePoints
  late PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  static final businessList = [
    {
      "title": "Business 1",
      "description": "This is a description",
      "image": "assets/images/business1.jpg",
      "location": "123 Main St, New York, NY 10001",
      "latitude": 40.7128,
      "longitude": -74.0060,
    },
    {
      "title": "Business 2",
      "description": "This is a description",
      "image": "assets/images/business2.jpg",
      "location": "123 Main St, New York, NY 10001",
      "latitude": 28.7041,
      "longitude": 77.1025,
    },
  ];

  var listOfBusiness = [];

  TextEditingController _search = TextEditingController();

  bool showSearch = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  initState() {
    super.initState();
    showSearch = true;
    _getCurrentLocation();
  }

  Future<List<Business>> getBusinessList() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        // var body = {
        //   "bId": currentBusiness?.bId.toString(),
        //   "lat": _position?.latitude.toString(),
        //   "long": _position?.longitude.toString(),
        // };
        var startDate = DateTime.now();
        var timeUtc = startDate.toUtc();
        var url =
            'http://rxfarm91.cse.buffalo.edu:5001/api/business?startDate=${startDate.toIso8601String()}';
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business location');
          var parsedJson = json.decode(response.body);
          return parsedJson
              .map<Business>((json) => Business.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to update business location');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  CameraPosition? _kGooglePlex;

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  // Create the polylines for showing the route between two places

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    try {
      // Initializing PolylinePoints
      polylinePoints = PolylinePoints();

      // Generating the list of coordinates to be used for
      // drawing the polylines
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDRgvNYgsN3izhrFArr_Uumwf3bbVasGJQ", // Google Maps API Key
        PointLatLng(startLatitude, startLongitude),
        PointLatLng(destinationLatitude, destinationLongitude),
        travelMode: TravelMode.transit,
      );

      // Adding the coordinates to the list
      if (result.points.isNotEmpty) {
        result.points.forEach(
          (PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          },
        );
      }

      // Defining an ID
      PolylineId id = PolylineId('poly');

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );

      // Adding the polyline to the map
      polylines[id] = polyline;
    } catch (e) {
      print(e);
    }
  }

  _getAddress() async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      // Taking the most probable result
      Placemark place = p[0];

      // Structuring the address
      var _currentAddress =
          "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

      // Update the text of the TextField
      startAddressController.text = _currentAddress;

      // Setting the user's present location as the starting address
      // _startAddress = _currentAddress;

    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;
        _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        );
        print('CURRENT POS: $_currentPosition');
      });
      // For moving the camera to current location
      (await _controller.future).animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<Business>>(
            future: getBusinessList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var listOfBusiness = snapshot.data;

                return listOfBusiness!.isEmpty
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
                    : Stack(
                        children: [
                          AbsorbPointer(
                            absorbing: showSearch,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _kGooglePlex ?? _kLake,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              polylines: Set<Polyline>.of(polylines.values),

                              markers: businessList
                                  .map(
                                    (business) => Marker(
                                      markerId:
                                          MarkerId(business["title"] as String),
                                      infoWindow: InfoWindow(
                                        title: business["title"] as String,
                                        snippet:
                                            business["description"] as String,
                                      ),
                                      position: LatLng(
                                        business["latitude"] as double,
                                        business["longitude"] as double,
                                      ),
                                    ),
                                  )
                                  .toSet(),
                              // myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                            ),
                          ),
                          showSearch
                              ? DraggableScrollableSheet(
                                  initialChildSize: 0.5,
                                  minChildSize: 0.3,
                                  maxChildSize: 1.0 -
                                      150 / MediaQuery.of(context).size.height,
                                  builder:
                                      (container, _scrollSheetController) =>
                                          Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: ListView(
                                        controller: _scrollSheetController,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Container(
                                                height: 6,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                            listOfBusiness.length,
                                            (index) => Material(
                                              key: ValueKey(index),
                                              child: InkWell(
                                                splashColor: secondaryColor,
                                                onTap: () async {
                                                  // await Future.delayed(
                                                  //   Duration(
                                                  //     milliseconds: 200,
                                                  //   ),
                                                  // );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BusinessDetail(
                                                        selectedBusiness:
                                                            listOfBusiness[
                                                                index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                  ),
                                                  margin: EdgeInsets.only(
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 10.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        thirdColor.withOpacity(
                                                      0.6,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        child: ListView(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 10.0,
                                                          ),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                20.0,
                                                              ),
                                                              child: Container(
                                                                width: 150,
                                                                child: listOfBusiness[
                                                                            index]
                                                                        .image1!
                                                                        .isEmpty
                                                                    ? FlutterLogo()
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            '${AppConstant.PICTURE_ASSET_PATH}/${listOfBusiness[index].image1}',
                                                                      ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        businessList[index]
                                                            ["title"] as String,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        'category',
                                                      ),
                                                      Text(
                                                        'Open: Closes 7pm',
                                                      ),
                                                      Row(
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
                                                          ActionChip(
                                                            onPressed: () {},
                                                            avatar: Icon(
                                                              Icons.directions,
                                                            ),
                                                            label: Text(
                                                              'Directions',
                                                            ),
                                                          ),
                                                          ActionChip(
                                                            onPressed: () {
                                                              Share.share(
                                                                  'check out my website https://openapp.com',
                                                                  subject:
                                                                      'Look what I made!');
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              : Container(),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            // height: 40
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 0.0,
                              ),
                              color: showSearch ? Colors.white : null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          50.0,
                                        ),
                                        borderSide: BorderSide(
                                          color: secondaryColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          50.0,
                                        ),
                                        borderSide: BorderSide(
                                          color: secondaryColor,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          50.0,
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    )),
                                    child: TextField(
                                      controller: _search,
                                      decoration: InputDecoration(
                                        hintText: "Enter your starting address",
                                        suffixIcon: showSearch
                                            ? IconButton(
                                                onPressed: () {
                                                  _search.clear();
                                                  setState(() {
                                                    showSearch = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: secondaryColor,
                                                ),
                                              )
                                            : null,
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            50.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 70.0,
                                    child: showSearch
                                        ? ListView(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                ),
                                                child: InputChip(
                                                  backgroundColor:
                                                      secondaryColor,
                                                  label: Icon(
                                                    Icons.sort,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FilterSearch()),
                                                    );
                                                  },
                                                ),
                                              ),
                                              //Relevance
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                ),
                                                child: InputChip(
                                                  label: Text('Relevance'),
                                                  selected: true,
                                                  deleteIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  selectedColor: thirdColor,
                                                  checkmarkColor:
                                                      secondaryColor,
                                                  onDeleted: () {
                                                    showModalBottomSheet(
                                                      isDismissible: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) =>
                                                          Container(
                                                        height: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            FilterSortBy(),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Clear',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Apply',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              //Price
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                ),
                                                child: InputChip(
                                                  label: Text('Price'),
                                                  deleteIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  selectedColor: thirdColor,
                                                  checkmarkColor:
                                                      secondaryColor,
                                                  selected: true,
                                                  onDeleted: () {
                                                    showModalBottomSheet(
                                                      isDismissible: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) =>
                                                          Container(
                                                        height: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            FilterPrice(),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      'Clear',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      'Apply',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),

                                              //Rating
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                ),
                                                child: InputChip(
                                                  label: Text('Rating'),
                                                  deleteIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  selectedColor: thirdColor,
                                                  checkmarkColor:
                                                      secondaryColor,
                                                  selected: true,
                                                  onDeleted: () {
                                                    showModalBottomSheet(
                                                      isDismissible: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) =>
                                                          Container(
                                                        height: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            FilterRating(),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      'Clear',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      'Apply',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),

                                              //Hour
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                ),
                                                child: InputChip(
                                                  label: Text('Hour'),
                                                  selectedColor: thirdColor,
                                                  checkmarkColor:
                                                      secondaryColor,
                                                  deleteIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  selected: true,
                                                  onDeleted: () {
                                                    showModalBottomSheet(
                                                      isDismissible: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) =>
                                                          Container(
                                                        height: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            FilterHour(),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      'Clear',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      'Apply',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),

                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 8.0),
                                              //   child: ElevatedButton(
                                              //     style: ButtonStyle(
                                              //       backgroundColor:
                                              //           MaterialStateProperty.all(
                                              //         Colors.white,
                                              //       ),
                                              //       padding: MaterialStateProperty.all(
                                              //         EdgeInsets.symmetric(
                                              //           horizontal: 20.0,
                                              //         ),
                                              //       ),
                                              //       foregroundColor:
                                              //           MaterialStateProperty.all(
                                              //         secondaryColor,
                                              //       ),
                                              //       shape: MaterialStateProperty.all(
                                              //         RoundedRectangleBorder(
                                              //           side: BorderSide(
                                              //             color: secondaryColor.withOpacity(
                                              //               0.5,
                                              //             ),
                                              //             width: 1,
                                              //           ),
                                              //           borderRadius: BorderRadius.circular(
                                              //             10,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     onPressed: () {},
                                              //     child: Text(
                                              //       'Relevance',
                                              //       style: TextStyle(
                                              //         fontSize: 14.0,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          )
                                        : ListView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ...List.generate(
                                                businessCategory.length,
                                                (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 10.0,
                                                  ),
                                                  child: InputChip(
                                                    key: ValueKey(index),
                                                    backgroundColor: thirdColor,
                                                    avatar: Icon(
                                                      Icons.coffee_outlined,
                                                    ),
                                                    elevation: 3.0,
                                                    label: Text(
                                                      businessCategory[index],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _search.text =
                                                          businessCategory[
                                                              index];
                                                      FocusScopeNode
                                                          currentFocus =
                                                          FocusScope.of(
                                                              context);

                                                      if (!currentFocus
                                                          .hasPrimaryFocus) {
                                                        currentFocus.unfocus();
                                                      }
                                                      //TODO: Search for the business

                                                      setState(() {
                                                        showSearch =
                                                            !showSearch;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              InputChip(
                                                backgroundColor: thirdColor,
                                                elevation: 3,
                                                avatar: Icon(
                                                  Icons.more_horiz_rounded,
                                                ),
                                                label: Text(
                                                  "More",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: ((context) =>
                                                          MoreFilter()),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          //current location

                          // Positioned(
                          //   right: 10,
                          //   bottom: 10,
                          //   child: ClipOval(
                          //     child: Material(
                          //       color: Colors.redAccent.shade100, // button color
                          //       child: InkWell(
                          //         splashColor: Colors.yellow, // inkwell color
                          //         child: SizedBox(
                          //           width: 56,
                          //           height: 56,
                          //           child: Icon(
                          //             Icons.my_location,
                          //             color: Colors.yellow,
                          //           ),
                          //         ),
                          //         onTap: () async {
                          //           // TODO: Add the operation to be performed
                          //           //   // on button tap
                          //           //   if (_controller != null && _currentPosition != null)
                          //           //     (await _controller.future).animateCamera(
                          //           //       CameraUpdate.newCameraPosition(
                          //           //         CameraPosition(
                          //           //           target: LatLng(
                          //           //             // Will be fetching in the next step
                          //           //             _currentPosition!.latitude,
                          //           //             _currentPosition!.longitude,
                          //           //           ),
                          //           //           zoom: 18.0,
                          //           //         ),
                          //           //       ),
                          //           //     );
                          //           //
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          //shop details
                          // Positioned(
                          //   left: 10,
                          //   right: 10,
                          //   bottom: 100,
                          //   height: 200,
                          //   child: PageView(
                          //       controller: _pageViewController,
                          //       physics: ClampingScrollPhysics(),
                          //       onPageChanged: (value) async {
                          //         // final GoogleMapController controller =
                          //         //     await _controller.future;
                          //         if (value == 0) {
                          //           (await _controller.future).animateCamera(
                          //             CameraUpdate.newCameraPosition(
                          //               CameraPosition(
                          //                 target: LatLng(
                          //                   // Will be fetching in the next step
                          //                   _currentPosition!.latitude,
                          //                   _currentPosition!.longitude,
                          //                 ),
                          //                 zoom: 18.0,
                          //               ),
                          //             ),
                          //           );
                          //         }
                          //         (await _controller.future).animateCamera(
                          //           CameraUpdate.newCameraPosition(
                          //             CameraPosition(
                          //               // bearing: 192.8334901395799,
                          //               target: LatLng(
                          //                   businessList[value - 1]["latitude"] as double,
                          //                   businessList[value - 1]["longitude"] as double),
                          //               // tilt: 59.440717697143555,
                          //               zoom: 19.151926040649414,
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //       children: [
                          //         Container(
                          //           alignment: Alignment.centerRight,
                          //           child: Container(
                          //             padding: EdgeInsets.all(10),
                          //             decoration: BoxDecoration(
                          //               color: Colors.white,
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(20),
                          //                 bottomLeft: Radius.circular(20),
                          //               ),
                          //             ),
                          //             child: Icon(
                          //               Icons.arrow_back,
                          //             ),
                          //           ),
                          //         ),
                          //         ...List.generate(
                          //           businessList.length,
                          //           (index) => Card(
                          //             key: ValueKey(index),
                          //             child: ListTile(
                          //               title: Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   Text(businessList[index]["title"] as String),
                          //                   Divider(),
                          //                   SizedBox(
                          //                     width: 100,
                          //                     height: 75,
                          //                     child: FlutterLogo(),
                          //                   ),
                          //                   Row(
                          //                     children: [
                          //                       Padding(
                          //                         padding: EdgeInsets.all(10),
                          //                         child: Container(
                          //                           padding: EdgeInsets.all(10),
                          //                           child: Text(
                          //                             '\$84',
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       Padding(
                          //                         padding: EdgeInsets.all(10),
                          //                         child: Container(
                          //                           padding: EdgeInsets.all(10),
                          //                           child: Text(
                          //                             '0.8 miles',
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   )
                          //                 ],
                          //               ),
                          //               subtitle: Text(
                          //                   businessList[index]["description"] as String),
                          //               trailing: IconButton(
                          //                 onPressed: () async {
                          //                   await _createPolylines(
                          //                       _currentPosition!.latitude,
                          //                       _currentPosition!.longitude,
                          //                       businessList[index]["latitude"] as double,
                          //                       businessList[index]["longitude"] as double);
                          //                 },
                          //                 icon: Icon(Icons.directions),
                          //                 color: Colors.blue,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ]),
                          // ),
                        ],
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: Text('To the lake!'),
        //   icon: Icon(Icons.directions_boat),
        // ),
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   // final GoogleMapController controller = await _controller.future;
  //   _controller!.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _controller.dispose();
    _pageViewController.dispose();
  }
}
