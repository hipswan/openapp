import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openapp/pages/widgets/Form/staff_form.dart';
import 'package:openapp/pages/widgets/staff_card.dart';
import 'package:openapp/pages/widgets/staff_profile.dart';

import '../../model/staff.dart';
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../business_home.dart';
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
    if (currentBusiness!.staff!.length > 0) {
      return currentBusiness!.staff!;
    }

    if (await CheckConnectivity.checkInternet()) {
      try {
        var response = await http.get(
          Uri.parse('${AppConstant.getBusinessStaff(
            currentBusiness?.bId,
          )})'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          var parsedJson = json.decode(response.body);
          currentBusiness!.staff =
              parsedJson.map<Staffs>((json) => Staff.fromJson(json)).toList();
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
        var response = await http.delete(
          Uri.parse(
              '${AppConstant.deleteBusinessStaff(currentBusiness?.bId, staffId)})'),
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
      body: FutureBuilder<List<Staff>>(
          future: getBusinessStaff(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 235,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return StaffCard(
                    key: ValueKey(index),
                    name: snapshot.data![index].firstName!,
                    position: 'Staff',
                    image: snapshot.data![index].profilePicture!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffProfile(
                            key: ValueKey(index),
                            staff: snapshot.data![index],
                            onDelete: () async {
                              await deleteBusinessStaff(
                                  snapshot.data![index].bId);
                              setState(() {});
                            },
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StaffForm(
                                    selectedStaff: snapshot.data![index],
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
              return Text("${snapshot.error}");
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
