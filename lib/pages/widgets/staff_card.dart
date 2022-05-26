import 'package:flutter/material.dart';
import 'package:openapp/pages/widgets/staff.dart';
import 'package:openapp/pages/widgets/staff_profile.dart';

import 'hex_color.dart';

class StaffCard extends StatelessWidget {
  final String name;
  final String position;
  final String image;
  final VoidCallback onTap;
  const StaffCard({
    Key? key,
    required this.name,
    required this.position,
    required this.onTap,
    required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            margin: EdgeInsets.all(20),
            child: Hero(
              tag: key.hashCode,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/icons/avatar.png',
                ),
              ),
            ),
          ),
          Text(
            '$name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Staff Position',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () {
              onTap();
            },
            child: Text(
              'show more',
              style: TextStyle(
                color: HexColor('#143F6B'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
