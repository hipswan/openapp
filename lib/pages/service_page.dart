import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Services'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
