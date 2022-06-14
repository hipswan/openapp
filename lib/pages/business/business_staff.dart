import 'package:flutter/material.dart';

class BusinessStaff extends StatefulWidget {
  const BusinessStaff({Key? key}) : super(key: key);

  @override
  State<BusinessStaff> createState() => _BusinessStaffState();
}

class _BusinessStaffState extends State<BusinessStaff> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Business Staff'),
      ),
    );
  }
}
