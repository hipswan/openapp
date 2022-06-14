import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openapp/widgets/Form/staff_form.dart';
import 'package:openapp/widgets/staff_card.dart';
import 'package:openapp/widgets/staff_profile.dart';

import '../../constant.dart';
import '../../model/staff.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../../pages/business/business_home.dart';

import 'hex_color.dart';
import 'package:http/http.dart' as http;

class Staffs extends StatefulWidget {
  const Staffs({Key? key}) : super(key: key);

  @override
  State<Staffs> createState() => _StaffsState();
}

class _StaffsState extends State<Staffs> {
  var isEditing = false;

  Future<List<Staff>> getBusinessStaff() async {
    // if (currentBusiness!.staff != null && currentBusiness!.staff!.length > 0) {
    //   return currentBusiness!.staff!;
    // }

    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.getBusinessStaff(
          currentBusiness?.bId,
        );
        var response = await http.get(
          Uri.parse('$url'),
          headers: {
            'Authorization': 'Bearer ${currentBusiness?.token}',
          },
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);

          currentBusiness!.staff =
              parsedJson.map<Staff>((json) => Staff.fromJson(json)).toList();
          return parsedJson.map<Staff>((json) => Staff.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch business staff');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to internet');
    }
  }

  Future deleteBusinessStaff(staffId) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url =
            AppConstant.deleteBusinessStaff(currentBusiness?.bId, staffId);
        var response = await http.delete(
          Uri.parse('$url'),
          headers: {
            'Authorization': 'Bearer ${currentBusiness?.token}',
          },
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          // var parsedJson = json.decode(response.body);
          // return parsedJson
          //     .map<Service>((json) => Service.fromJson(json))
          //     .toList();
          currentBusiness!.staff = currentBusiness!.staff
              ?.where((staff) => staff.bId != staffId)
              .toList();
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

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    final _staffDetails = [
      {
        'name': 'John Doe',
        'position': 'Manager',
        'image': 'assets/images/staff/staff_1.png',
      },
      {
        'name': 'Jane Doe',
        'position': 'Receptionist',
        'image': 'assets/images/staff/staff_2.png',
      },
      {
        'name': 'John Doe',
        'position': 'Manager',
        'image': 'assets/images/staff/staff_1.png',
      },
      {
        'name': 'Jane Doe',
        'position': 'Receptionist',
        'image': 'assets/images/staff/staff_2.png',
      },
      {
        'name': 'John Doe',
        'position': 'Manager',
        'image': 'assets/images/staff/staff_1.png',
      },
      {
        'name': 'Jane Doe',
        'position': 'Receptionist',
        'image': 'assets/images/staff/staff_2.png',
      },
      {
        'name': 'John Doe',
        'position': 'Manager',
        'image': 'assets/images/staff/staff_1.png',
      },
      {
        'name': 'Jane Doe',
        'position': 'Receptionist',
        'image': 'assets/images/staff/staff_2.png',
      },
      {
        'name': 'John Doe',
        'position': 'Manager',
        'image': 'assets/images/staff/staff_1.png',
      },
      {
        'name': 'Jane Doe',
        'position': 'Receptionist',
        'image': 'assets/images/staff/staff_2.png',
      },
      {
        'name': 'John Doe',
        'position': 'Manager',
        'image': 'assets/images/staff/staff_1.png',
      },
      {
        'name': 'Jane Doe',
        'position': 'Receptionist',
        'image': 'assets/images/staff/staff_2',
      }
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#143F6B'),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StaffForm(),
            ),
          );
          // setState(() {
          //   isEditing = !isEditing;
          // });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Staff',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Select a staff to view its details'),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<Staff>>(
                future: getBusinessStaff(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var listOfStaff = snapshot.data;
                      return listOfStaff!.isEmpty
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
                          : GridView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemCount: listOfStaff.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 235,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return StaffCard(
                                  key: ValueKey(index),
                                  name: '${listOfStaff[index].firstName}',
                                  position: 'Staff',
                                  image: '${listOfStaff[index].profilePicture}',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StaffProfile(
                                          staff: listOfStaff[index],
                                          onDelete: () async {
                                            await deleteBusinessStaff(
                                                listOfStaff[index].bId);
                                            setState(() {});
                                          },
                                          onEdit: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => StaffForm(
                                                  selectedStaff:
                                                      listOfStaff[index],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/error.svg',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              'There seems to be Issue while fetching staff details from server'),
                          // Text(snapshot.error.toString()),

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
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Reload',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {});
                            },
                          ),
                        ],
                      ));
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
