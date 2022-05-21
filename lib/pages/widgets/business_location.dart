import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openapp/constant.dart';

class BusinessLocation extends StatefulWidget {
  const BusinessLocation({Key? key}) : super(key: key);

  @override
  State<BusinessLocation> createState() => _BusinessLocationState();
}

class _BusinessLocationState extends State<BusinessLocation> {
  bool _islocation = false;
  bool _isloading = false;
  String _location = '';
  Position? _position;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getAddress(position) async {
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
      return null;
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
                          setState(() {
                            _location = location;
                            _position = position;
                            _islocation = true;
                            _isloading = false;
                          });
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
  MapBox({
    Key? key,
    required this.position,
    required this.location,
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
                      title: '/business name',
                      snippet: '/description',
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
