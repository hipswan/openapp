import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:openapp/model/shop.dart';
import 'package:openapp/widgets/user_drawer.dart';
import '../../model/category.dart';
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

class ClientMapState extends State<ClientMap>
    with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _controller = Completer();
  // For storing the current position
  Position? _currentPosition;
  PageController _pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 0.85,
  );

  var businessCategory = [
    'Doctor',
    'Cafe',
  ];
  ScaffoldState _scaffoldState = ScaffoldState();

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

  List<Shop> listOfBusiness = [];

  DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  ValueNotifier<Set<Marker>> markers = ValueNotifier(Set());

  var currentCategoryID;

  TextEditingController _search = TextEditingController();

  bool showSearch = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  initState() {
    super.initState();
    reqPermission().then((value) {
      if (value)
        _getCurrentLocation();
      else
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Permission Denied"),
            content: Text("Please enable location permission"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
    });

    // showSearch = true;
  }

  Future<List<Shop>> getBusinessList() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        // var body = {
        //   "bId": currentBusiness?.bId.toString(),
        //   "lat": _position?.latitude.toString(),
        //   "long": _position?.longitude.toString(),
        // };
        var url = AppConstant.getBusinesses(currentCategoryID.toString());
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business location');
          var parsedJson = json.decode(response.body);
          List<Shop> shopList =
              parsedJson.map<Shop>((shop) => Shop.fromJson(shop)).toList();

          markers.value = Set<Marker>.from(listOfBusiness.map<Marker>((shop) {
            // if (shop.location!.coordinates![0] > maxLatitude) {
            //   maxLatitude = shop.location!.coordinates![0];
            // }
            // if (shop.location!.coordinates![0] < minLatitude) {
            //   minLatitude = shop.location!.coordinates![0];
            // }
            // if (shop.location!.coordinates![1] > maxLongitude) {
            //   maxLongitude = shop.location!.coordinates![1];
            // }
            // if (shop.location!.coordinates![1] < minLongitude) {
            //   minLongitude = shop.location!.coordinates![1];
            // }
            return Marker(
              markerId: MarkerId(shop.id.toString()),
              position: LatLng(shop.location!.coordinates![1],
                  shop.location!.coordinates![0]),
              infoWindow: InfoWindow(
                title: shop.name,
                snippet: shop.location!.formattedAddress,
              ),
              onTap: () {},
            );
          }));

          return shopList;
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

  Future<List<Category>> getBusinessCategory() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        // var body = {
        //   "bId": currentBusiness?.bId.toString(),
        //   "lat": _position?.latitude.toString(),
        //   "long": _position?.longitude.toString(),
        // };

        var url = AppConstant.CATEGORY;
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business category');
          var parsedJson = json.decode(response.body);
          return parsedJson
              .map<Category>((json) => Category.fromJson(json))
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
  // Ask permission from device
  Future<bool> reqPermission() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      LocationPermission locationPermision =
          await GeolocatorPlatform.instance.checkPermission();
      if (locationPermision == LocationPermission.denied ||
          locationPermision == LocationPermission.deniedForever ||
          locationPermision == LocationPermission.unableToDetermine) {
        await GeolocatorPlatform.instance.requestPermission();
        return await GeolocatorPlatform.instance.checkPermission() ==
                LocationPermission.always ||
            await GeolocatorPlatform.instance.checkPermission() ==
                LocationPermission.whileInUse;
      } else {
        return true;
      }
    }
    return false;
  }

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
        drawer: UserDrawer(),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<Category>>(
            future: getBusinessCategory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var listOfCategory = snapshot.data;

                return listOfCategory!.isEmpty
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
                          ValueListenableBuilder<Set<Marker>>(
                            valueListenable: markers,
                            builder: (context, value, child) => GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _kGooglePlex ?? _kLake,
                              markers: value,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              onTap: (LatLng latLng) {},
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                            ),
                          ),
                          showSearch
                              ? DraggableScrollableSheet(
                                  initialChildSize: 0.5,
                                  minChildSize: 0.1,
                                  maxChildSize: 0.8,
                                  builder:
                                      (container, _scrollSheetController) =>
                                          Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.6,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                          child: FutureBuilder<List<Shop>>(
                                            future: getBusinessList(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                listOfBusiness = snapshot.data!;

                                                SchedulerBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  var maxLatitude = -90.0;
                                                  var maxLongitude = -180.0;
                                                  var minLatitude = 90.0;
                                                  var minLongitude = 180.0;
                                                  listOfBusiness
                                                      .forEach((business) {
                                                    maxLatitude = max(
                                                        business.location!
                                                            .coordinates![1],
                                                        maxLatitude);

                                                    maxLongitude = max(
                                                        business.location!
                                                            .coordinates![0],
                                                        maxLongitude);

                                                    minLatitude = min(
                                                        business.location!
                                                            .coordinates![1],
                                                        minLatitude);

                                                    minLongitude = min(
                                                        business.location!
                                                            .coordinates![0],
                                                        minLongitude);
                                                  });
                                                  _controller.future
                                                      .then((controller) {
                                                    controller.animateCamera(
                                                      CameraUpdate
                                                          .newCameraPosition(
                                                        CameraPosition(
                                                          target: LatLng(
                                                            maxLatitude -
                                                                ((maxLatitude
                                                                            .abs() -
                                                                        minLatitude
                                                                            .abs()) /
                                                                    2),
                                                            maxLongitude -
                                                                ((maxLongitude
                                                                            .abs() -
                                                                        minLongitude
                                                                            .abs()) /
                                                                    2),
                                                          ),
                                                          zoom: 10.0,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                                return ListView(
                                                  controller:
                                                      _scrollSheetController,
                                                  children: [
                                                    ...List.generate(
                                                      listOfBusiness.length,
                                                      (index) => Material(
                                                        key: ValueKey(index),
                                                        child: InkWell(
                                                          splashColor:
                                                              secondaryColor,
                                                          onTap: () async {
                                                            await Future
                                                                .delayed(
                                                              Duration(
                                                                milliseconds:
                                                                    200,
                                                              ),
                                                            );
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BusinessDetail(
                                                                  selectedBusiness:
                                                                      listOfBusiness[
                                                                          index],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 20.0,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                              bottom: 10.0,
                                                              left: 10.0,
                                                              right: 10.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: thirdColor
                                                                  .withOpacity(
                                                                0.6,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    secondaryColor,
                                                                width: 0.5,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 20,
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              125,
                                                                          child: listOfBusiness[index].images![0].isEmpty
                                                                              ? Image.asset(
                                                                                  'assets/images/icons/open_app.png',
                                                                                  fit: BoxFit.cover,
                                                                                )
                                                                              : CachedNetworkImage(
                                                                                  imageUrl: '${listOfBusiness[index].images![0]}',
                                                                                  errorWidget: (context, error, errorDynamic) => Image.asset('assets/images/icons/open_app.png'),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              listOfBusiness[index].name as String,
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'Type: ${listOfBusiness[index].category as String}',
                                                                              strutStyle: StrutStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'Open: Closes 7pm',
                                                                              strutStyle: StrutStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      ActionChip(
                                                                        backgroundColor:
                                                                            secondaryColor,
                                                                        avatar:
                                                                            Icon(
                                                                          Icons
                                                                              .call,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              thirdColor,
                                                                        ),
                                                                        elevation:
                                                                            3,
                                                                        label:
                                                                            Text(
                                                                          'Call',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                thirdColor,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {},
                                                                      ),
                                                                      Spacer(),
                                                                      ActionChip(
                                                                        backgroundColor:
                                                                            secondaryColor,
                                                                        onPressed:
                                                                            () {},
                                                                        avatar:
                                                                            Icon(
                                                                          Icons
                                                                              .directions,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              thirdColor,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          'Directions',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                thirdColor,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      ActionChip(
                                                                        backgroundColor:
                                                                            secondaryColor,
                                                                        onPressed:
                                                                            () {
                                                                          Share.share(
                                                                              'check out my website http://rxfarm91.cse.buffalo.edu:500/',
                                                                              subject: 'Reserve your favourite spot in an instance!');
                                                                        },
                                                                        avatar:
                                                                            Icon(
                                                                          Icons
                                                                              .share,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              thirdColor,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          'Share',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                thirdColor,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]..add(
                                                      SizedBox(
                                                        height: 100,
                                                      ),
                                                    ),
                                                );
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              CircleBorder(),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              secondaryColor,
                                            ),
                                            padding: MaterialStateProperty.all(
                                              EdgeInsets.all(
                                                14.0,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            _scaffoldKey.currentState!
                                                .openDrawer();
                                          },
                                          child: Icon(
                                            Icons.menu,
                                            color: thirdColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              inputDecorationTheme:
                                                  InputDecorationTheme(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: secondaryColor,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: secondaryColor,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                              hintText:
                                                  "Enter your starting address",
                                              suffixIcon: showSearch
                                                  ? IconButton(
                                                      onPressed: () {
                                                        _search.clear();
                                                        _controller.future
                                                            .then((controller) {
                                                          controller
                                                              .animateCamera(
                                                            CameraUpdate
                                                                .newCameraPosition(
                                                              CameraPosition(
                                                                target: LatLng(
                                                                  _currentPosition!
                                                                      .latitude,
                                                                  _currentPosition!
                                                                      .longitude,
                                                                ),
                                                                zoom: 18.0,
                                                              ),
                                                            ),
                                                          );
                                                        });

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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  50.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                                            FilterSearch(),
                                                      ),
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
                                                listOfCategory.length,
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
                                                      listOfCategory[index]
                                                              .title ??
                                                          "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _search.text =
                                                          listOfCategory[index]
                                                                  .title ??
                                                              "";
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
                                                        currentCategoryID =
                                                            listOfCategory[
                                                                    index]
                                                                .id;
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await Future.delayed(
        //       Duration(
        //         milliseconds: 200,
        //       ),
        //     );
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => BusinessDetail(
        //     //       selectedBusiness: listOfBusiness[index],
        //     //     ),
        //     //   ),
        //     // );
        //   },
        //   backgroundColor: secondaryColor,
        //   child: Icon(
        //     Icons.list,
        //     size: 32,
        //     color: thirdColor,
        //   ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
