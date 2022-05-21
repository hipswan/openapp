import 'package:flutter/material.dart';
import 'package:openapp/pages/widgets/Form/staff_form.dart';
import 'package:openapp/pages/widgets/staff_card.dart';

import 'hex_color.dart';

class Staff extends StatefulWidget {
  const Staff({Key? key}) : super(key: key);

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  var isEditing = false;

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
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _staffDetails.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 235,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return StaffCard(
            key: ValueKey(index),
            name: _staffDetails[index]['name']!,
            position: _staffDetails[index]['position']!,
          );
        },
      ),
    );
  }
}
