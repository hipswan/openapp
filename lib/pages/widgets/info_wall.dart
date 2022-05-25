import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../business_home.dart';
import 'hex_color.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
// [
//   {
//     "bId": "2",
//     "day": 0,
//     "isWorking": false,
//     "startTime": null,
//     "endTime": null
//   },

// ]
class InfoWall extends StatefulWidget {
  const InfoWall({Key? key}) : super(key: key);

  @override
  State<InfoWall> createState() => _InfoWallState();
}

class _InfoWallState extends State<InfoWall> {
  var isEditing = false;

  var _daysOperating = {
    'Mon': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Tue': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Wed': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Thu': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Fri': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Sat': {'active': false, 'from': '00:00', 'to': '00:00'},
  };

  Future getBusinessHours() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var response = await http.get(
          Uri.parse('${AppConstant.getBusinesssHourById(
            currentBusiness?.bId,
          )})'),
        );

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

  getWeekInWords(day) {
    switch (day) {
      case "0":
        return 'Mon';
      case "1":
        return 'Tue';
      case "2":
        return 'Wed';
      case "3":
        return 'Thu';
      case "4":
        return 'Fri';
      case "5":
        return 'Sat';
      case "6":
        return 'Sun';
      default:
        return 'Mon';
    }
  }

  getWeekInNumber(week) {
    switch (week) {
      case "Mon":
        return '0';
      case "Tue":
        return '1';
      case "Wed":
        return '2';
      case "Thu":
        return '3';
      case "Fri":
        return '4';
      case "Sat":
        return '5';
      case "Sun":
        return '6';
      default:
        return '0';
    }
  }

  Future maintainBusinessHours() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = _daysOperating.entries.map((element) {
          return {
            "bId": currentBusiness?.bId,
            "day": getWeekInNumber(element.key),
            "isWorking": element.value['active'],
            "startTime": element.value['from'],
            "endTime": element.value['to'],
          };
        }).toList();
        var response = await http.patch(
          Uri.parse('${AppConstant.addBusinessStaff(currentBusiness?.bId)}'),
          body: body,
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business hours');
        } else {
          throw Exception('Failed to update business hours');
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
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#143F6B'),
        onPressed: () async {
          // Navigator.pushNamed(context, '/staff_add');
          if (isEditing) {
            //TODO: loader start
            maintainBusinessHours().then((value) {
              setState(() {
                isEditing = false;
              });
            }).catchError((error) {
              dev.log(error);
            });
            //TODO: loader end
          }
          setState(() {
            isEditing = !isEditing;
          });
        },
        child: isEditing
            ? Icon(
                Icons.save_alt_rounded,
                color: Colors.white,
              )
            : Icon(
                Icons.edit,
                color: Colors.white,
              ),
      ),
      body: FutureBuilder(
          future: getBusinessHours(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List? businessHour = snapshot.data as List;
              if (businessHour.length > 0) {
                businessHour.forEach((element) {
                  var dayInWords =
                      getWeekInWords(element['day']?.toString() ?? '');
                  _daysOperating[dayInWords] = {
                    'active': element['isWorking'],
                    'from': element['startTime'] ?? '00:00',
                    'to': element['endTime'] ?? '00:00',
                  };
                });
              }
              return Container(
                height: maxHeight,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Business Hours',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Wrap(
                      children: _daysOperating.entries.map((element) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: SizedBox(
                                    height: 20,
                                    width: 35,
                                    child:
                                        Center(child: Text('${element.key}'))),
                                selected: element.value['active'] as bool,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                selectedColor: Colors.blue,
                                onSelected: (bool selected) {
                                  isEditing
                                      ? setState(() {
                                          _daysOperating[element.key]![
                                              'active'] = selected;
                                          _daysOperating[element.key]!['from'] =
                                              '00:00';
                                          _daysOperating[element.key]!['to'] =
                                              '00:00';
                                        })
                                      : print('not editing');
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: element.value['from'] as String),
                                  enabled: element.value['active'] as bool,
                                  keyboardType: TextInputType.none,
                                  onTap: () async {
                                    isEditing
                                        ? await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            setState(() {
                                              _daysOperating[element.key]![
                                                      'from'] =
                                                  '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
                                            });
                                          })
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: element.value['to'] as String),
                                  enabled: element.value['active'] as bool,
                                  keyboardType: TextInputType.none,
                                  onTap: () async {
                                    isEditing
                                        ? await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            setState(() {
                                              _daysOperating[element.key]![
                                                      'to'] =
                                                  '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
                                            });
                                          })
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
