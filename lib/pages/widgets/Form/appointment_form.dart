import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';

import '../../../model/business.dart';
import '../../../model/service.dart';
import '../../../model/staff.dart';
import '../../../utility/Network/network_connectivity.dart';
import '../../../utility/appurl.dart';
import '../../business_home.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import '../../login_page.dart';

class AppointmentForm extends StatefulWidget {
  final Business selectedBusiness;
  final List<Service> serviceList;
  final List<Staff> staffList;
  const AppointmentForm(
      {Key? key,
      required this.selectedBusiness,
      required this.staffList,
      required this.serviceList})
      : super(key: key);

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  var networkImgPath;
  var imagePath;
  TextEditingController _notes = TextEditingController();
  TextEditingController _date = TextEditingController();

  List<DropdownMenuItem<int>> staffDropDownList = [];
  int? staffId;
  List<DropdownMenuItem<int>> serviceDropDownList = [];
  int? serviceId;

  List<DropdownMenuItem<String>> _times = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    staffDropDownList = widget.staffList.map<DropdownMenuItem<int>>((staff) {
      return DropdownMenuItem(
        child: Text(staff.firstName!),
        value: staff.id,
      );
    }).toList();

    serviceDropDownList =
        widget.serviceList.map<DropdownMenuItem<int>>((service) {
      return DropdownMenuItem<int>(
        child: Text(service.serviceName!),
        value: service.id,
      );
    }).toList();
    super.initState();
  }

  Future postAppointment() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = {
          "serviceId": serviceId,
          "date": _date.text,
          "startDateTime": _date.text,
          "bId": widget.selectedBusiness.bId.toString(),
          "uId": currentClient!.id.toString(),
          "staffId": staffId,
          "notes": _notes.text,
        };
        var url = 'http://rxfarm91.cse.buffalo.edu:5001/api/appointments/book';

        var response = await http.post(
          Uri.parse('$url'),
          body: body,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${currentClient?.token}',
          },
        );

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204) {
          //  json.decode(response.body);
          // dev.log('added/updated business location');
          var parsedJson = json.decode(response.body);
          return parsedJson;
        } else {
          throw Exception('Failed to fetch appointments');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  Future getTimeAvaialbility(DateTime date) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var startDate = DateTime.now();
        var url =
            'http://rxfarm91.cse.buffalo.edu:5001/api/business?bId=${widget.selectedBusiness.bId}&startDate=${startDate}';

        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          // dev.log('added/updated business location');
          var parsedJson = json.decode(response.body);
          return parsedJson;
        } else {
          throw Exception('Failed to fetch appointments');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Manage Appointment'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              await Future.delayed(Duration(milliseconds: 100));
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (_formKey.currentState!.validate()) {
                    await postAppointment();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: secondaryColor.withOpacity(
                    0.8,
                  ),
                  child: Text(
                    'Saved to: /businessname',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    value: serviceId,
                    items: serviceDropDownList,
                    onChanged: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _date,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2050),
                      );
                      _date.text = pickedDate.toString();
                      var res = await getTimeAvaialbility(pickedDate!);
                      _times = res[0]['availableAppointments']
                          .map<DropdownMenuItem<String>>((time) {
                        return DropdownMenuItem<String>(
                          child: Text(time['time']),
                          value: time['time'],
                        );
                      }).toList();
                      setState(() {
                        // _availableStaff = res[0]['availableStaff'].map<DropdownMenuItem<String>>((staff) {
                        //   return DropdownMenuItem(
                        //     child: Text(staff['firstName']),
                        //     value: staff['firstName'],
                        //   );
                        // }).toList();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Pick a desired date',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                _times.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          items: _times,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            labelText: 'Pick a desired time',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Staff Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    value: staffId,
                    items: staffDropDownList,
                    onChanged: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    controller: _notes,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Service Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
