import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/model/shop.dart';

import '../../../model/business.dart';
import '../../../model/service.dart';
import '../../../model/staff.dart';
import '../../../utility/Network/network_connectivity.dart';
import '../../../utility/appurl.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import '../../main.dart';
import '../../model/slot.dart';
import '../../pages/login_page.dart';

class AppointmentForm extends StatefulWidget {
  final Shop selectedBusiness;

  const AppointmentForm({
    Key? key,
    required this.selectedBusiness,
  }) : super(key: key);

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  var networkImgPath;
  var imagePath;
  TextEditingController _notes = TextEditingController();
  TextEditingController _date = TextEditingController();
  bool isLoading = true;
  List<DropdownMenuItem<int>> staffDropDownList = [];
  int? staffId;
  List<DropdownMenuItem<String>> serviceDropDownList = [];
  String? serviceId;
  DateTime? _selectedDate;
  List<Slot> _slots = [];
  int? _selectedSlot;
  List<DropdownMenuItem<String>> _times = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    // staffDropDownList = widget.staffList.map<DropdownMenuItem<int>>((staff) {
    //   return DropdownMenuItem(
    //     child: Text(staff.firstName!),
    //     value: staff.id,
    //   );
    // }).toList();
    getBusinessServices().then((services) {
      setState(() {
        isLoading = false;
        serviceDropDownList = services.map<DropdownMenuItem<String>>((service) {
          return DropdownMenuItem<String>(
            child: Text(service.name ?? ''),
            value: service.id ?? '',
          );
        }).toList();
      });
    });

    super.initState();
  }

  Future<List<Service>> getBusinessServices() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        String url = AppConstant.getBusinessService(widget.selectedBusiness.id);
        var request = http.Request(
          'GET',
          Uri.parse(url),
        );
        request.bodyFields = {};

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var parsedJson = json.decode(await response.stream.bytesToString());
          return parsedJson
              .map<Service>((json) => Service.fromJson(json))
              .toList();
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

  Future postAppointment(Slot selectedSlot) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = {
          "startTime": selectedSlot.start!.toIso8601String(),
          "serviceId": serviceId,
        };
        var url = AppConstant.bookAppointment(widget.selectedBusiness.id);

        var response = await http.post(
          Uri.parse('$url'),
          body: body,
          headers: {
            'x-auth-token': '${currentCustomer!.token}',
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          //  json.decode(response.body);
          dev.log('Slot Booked Successsfully');
          var parsedJson = json.decode(response.body);
          return parsedJson;
        } else {
          var parsedJson = json.decode(response.body);
          throw Exception(parsedJson["msg"].toString());
        }
      } catch (e) {
        throw e;
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  Future<List<Slot>> getTimeAvaialbility(DateTime _date, serviceId) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        print(_date.toIso8601String());
        print(_date.toUtc());
        var url = AppConstant.getSlots(
          businessId: widget.selectedBusiness.id,
          date: _date.toIso8601String(),
          serviceId: serviceId,
        );

        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          // dev.log('added/updated business location');
          var parsedJson = json.decode(response.body);
          return parsedJson.map<Slot>((json) => Slot.fromJson(json)).toList();
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

  FocusNode dateInputFocusNode = FocusNode();

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
                    // await postAppointment();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Book',
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
                isLoading
                    ? LinearProgressIndicator(
                        backgroundColor: thirdColor,
                        color: secondaryColor.withOpacity(0.8),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: secondaryColor.withOpacity(
                    0.8,
                  ),
                  child: Text(
                    'Make an Appointment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'Please select a service' : null,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      hintText: 'Select Service in the list',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    value: serviceId,
                    items: serviceDropDownList,
                    onChanged: (value) {
                      setState(() {
                        _slots = [];
                        serviceId = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _date,
                    focusNode: dateInputFocusNode,
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2050),
                      );

                      _date.text = DateFormat.yMMMMEEEEd().format(pickedDate!);
                      if (dateInputFocusNode.hasPrimaryFocus) {
                        dateInputFocusNode.unfocus();
                      }
                      setState(() {
                        // _availableStaff = res[0]['availableStaff'].map<DropdownMenuItem<String>>((staff) {
                        //   return DropdownMenuItem(
                        //     child: Text(staff['firstName']),
                        //     value: staff['firstName'],
                        //   );
                        // }).toList();
                        _slots = [];
                        _selectedDate = pickedDate;
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
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          _slots = await getTimeAvaialbility(
                              _selectedDate!, serviceId);

                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Slots Not Found'),
                                  actions: [
                                    ElevatedButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Get Slots',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _slots.length == 0
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            width: double.infinity,
                            child: Text(
                              'Available Slots',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              alignment: WrapAlignment.start,
                              children: List<Widget>.generate(
                                _slots.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: ChoiceChip(
                                      key: ValueKey(_slots[index]),
                                      padding: EdgeInsets.all(
                                        8.0,
                                      ),
                                      avatar: Icon(
                                        Icons.watch_later_outlined,
                                        color: thirdColor,
                                      ),
                                      backgroundColor: secondaryColor,
                                      label: Text(
                                        DateFormat("hh:mm a")
                                            .format(_slots[index].start!),
                                        style: TextStyle(
                                          color: thirdColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      selected: _selectedSlot == index,
                                      selectedColor: Colors.redAccent,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedSlot =
                                              selected ? index : null;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(secondaryColor),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (_formKey.currentState!.validate() &&
                                    _selectedSlot != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    await postAppointment(
                                        _slots[_selectedSlot!]);

                                    setState(() {
                                      _slots = [];
                                      isLoading = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                '${e.toString()}\n Facing issue with this slot, please try again later'),
                                            actions: [
                                              ElevatedButton(
                                                child: Text('Ok'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          )),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Book Slot',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
