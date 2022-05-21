import 'package:flutter/material.dart';

class BusinessServices extends StatefulWidget {
  const BusinessServices({Key? key}) : super(key: key);

  @override
  State<BusinessServices> createState() => _BusinessServicesState();
}

class _BusinessServicesState extends State<BusinessServices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Business Services'),
      ),
    );
  }
}
