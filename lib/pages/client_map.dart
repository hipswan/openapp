import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

  initState() {
    super.initState();
    _getCurrentLocation();
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex ?? _kLake,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: Set<Polyline>.of(polylines.values),

              markers: businessList
                  .map(
                    (business) => Marker(
                      markerId: MarkerId(business["title"] as String),
                      infoWindow: InfoWindow(
                        title: business["title"] as String,
                        snippet: business["description"] as String,
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
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                // height: 40
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  child: TextField(
                    controller: startAddressController,
                    decoration: InputDecoration(
                      hintText: "Enter your starting address",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                )),
            Positioned(
              right: 10,
              bottom: 10,
              child: ClipOval(
                child: Material(
                  color: Colors.redAccent.shade100, // button color
                  child: InkWell(
                    splashColor: Colors.yellow, // inkwell color
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.yellow,
                      ),
                    ),
                    onTap: () async {
                      // TODO: Add the operation to be performed
                      // on button tap
                      if (_controller != null && _currentPosition != null)
                        (await _controller.future).animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                // Will be fetching in the next step
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 100,
              height: 200,
              child: PageView(
                  controller: _pageViewController,
                  physics: ClampingScrollPhysics(),
                  onPageChanged: (value) async {
                    // final GoogleMapController controller =
                    //     await _controller.future;
                    if (value == 0) {
                      (await _controller.future).animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(
                              // Will be fetching in the next step
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 18.0,
                          ),
                        ),
                      );
                    }
                    (await _controller.future).animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          // bearing: 192.8334901395799,
                          target: LatLng(
                              businessList[value - 1]["latitude"] as double,
                              businessList[value - 1]["longitude"] as double),
                          // tilt: 59.440717697143555,
                          zoom: 19.151926040649414,
                        ),
                      ),
                    );
                  },
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),
                    ...List.generate(
                      businessList.length,
                      (index) => Card(
                        key: ValueKey(index),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(businessList[index]["title"] as String),
                              Divider(),
                              SizedBox(
                                width: 100,
                                height: 75,
                                child: FlutterLogo(),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '\$84',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '0.8 miles',
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          subtitle: Text(
                              businessList[index]["description"] as String),
                          trailing: IconButton(
                            onPressed: () async {
                              await _createPolylines(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                  businessList[index]["latitude"] as double,
                                  businessList[index]["longitude"] as double);
                            },
                            icon: Icon(Icons.directions),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
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
