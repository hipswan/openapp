import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openapp/constant.dart';
import '../../pages/business/business_home.dart';

import '../../utility/Network/network_connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import '../../utility/appurl.dart';
import '../model/shop.dart';

class BusinessLocation extends StatefulWidget {
  final Shop? selectedBusiness;
  const BusinessLocation({Key? key, this.selectedBusiness}) : super(key: key);

  @override
  State<BusinessLocation> createState() => _BusinessLocationState();
}

class _BusinessLocationState extends State<BusinessLocation> {
  bool _islocation = false;
  bool _isloading = true;
  String _location = '';
  Position? _position;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectedBusiness != null &&
        widget.selectedBusiness!.location != null &&
        widget.selectedBusiness?.location?.coordinates != null &&
        widget.selectedBusiness?.location?.coordinates?.length == 2) {
      _position = Position(
        latitude: widget.selectedBusiness!.location!.coordinates![1],
        longitude: widget.selectedBusiness!.location!.coordinates![0],
        accuracy: 0.0,
        altitude: 0.0,
        speed: 0.0,
        timestamp: DateTime.now(),
        heading: 0.0,
        speedAccuracy: 0.0,
      );
      _location = widget.selectedBusiness!.location!.formattedAddress!;

      setState(() {
        _islocation = true;
        _isloading = false;
      });
    } else {
      setState(() {
        _isloading = false;
      });
    }
    super.initState();
  }

  Future<String> _getAddress(position) async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);

      // Taking the most probable result
      Placemark place = p[0];

      // Structuring the address
      return "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
      return "{e.toString()}";
    }
  }

  _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future updateBusinessLocation() async {
  //   if (await CheckConnectivity.checkInternet()) {
  //     try {
  //       var body = {
  //         "bId": widget.selectedBusiness?.bId.toString(),
  //         "lat": _position?.latitude.toString(),
  //         "long": _position?.longitude.toString(),
  //       };
  //       var url = AppConstant.getBusiness(widget.selectedBusiness?.bId);
  //       var response = await http.patch(
  //         Uri.parse('$url'),
  //         body: body,
  //       );

  //       if (response.statusCode == 200) {
  //         //  json.decode(response.body);
  //         dev.log('added/updated business location');
  //       } else {
  //         throw Exception('Failed to update business location');
  //       }
  //     } catch (e) {
  //       throw Exception('Failed to connect to server');
  //     }
  //   } else {
  //     throw Exception('Failed to connect to Intenet');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: !_islocation && !_isloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/location.svg',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                        Icons.gps_fixed_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add Location',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isloading = true;
                        });
                        var position = await _getCurrentLocation();

                        if (position is Position) {
                          var location = await _getAddress(position);
                          _location = location;
                          _position = position;
                          _islocation = true;
                          _isloading = false;
                          // await updateBusinessLocation();
                          // widget.selectedBusiness?.lat =
                          //     _position?.latitude.toString();
                          // widget.selectedBusiness?.long =
                          //     _position?.longitude.toString();
                          setState(() {});
                        } else {
                          setState(() {
                            _isloading = false;
                          });
                          print('No location found');
                        }
                      },
                    ),
                  ],
                ),
              )
            : !_isloading
                ? MapBox(
                    position: _position!,
                    location: _location,
                    title: '${widget.selectedBusiness?.name}',
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}

class MapBox extends StatelessWidget {
  final Position position;
  final String location;
  final String title;
  MapBox({
    Key? key,
    required this.position,
    required this.location,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 200,
              child: GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  // _controller.complete(controller);
                },
                markers: {
                  Marker(
                    markerId: MarkerId('1'),
                    infoWindow: InfoWindow(
                      title: title,
                      snippet: location,
                    ),
                    position: LatLng(
                      position.latitude,
                      position.longitude,
                    ),
                  ),
                },
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Text(
            location,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
