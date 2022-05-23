import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';

class StaffForm extends StatefulWidget {
  const StaffForm({Key? key}) : super(key: key);

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  File? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Maintain Staff'),
        centerTitle: true,
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
              onPressed: () {},
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
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red.shade100,
                        ),
                        shape: MaterialStateProperty.all(
                          CircleBorder(),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.all(18),
                        ),
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Add a profile photo',
                        strutStyle: StrutStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConnectTile(
                  asset: 'assets/images/connects/ig_logo.png',
                  label: 'Instagram',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConnectTile(
                  asset: 'assets/images/connects/tiktok_logo.png',
                  label: 'TikTok',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConnectTile(
                  asset: 'assets/images/connects/fb_logo.png',
                  label: 'Facebook',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
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
    );
  }
}

class ConnectTile extends StatelessWidget {
  final String asset;
  final String label;
  ConnectTile({
    Key? key,
    required this.asset,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          width: 48,
          height: 48,
          image: AssetImage(
            asset,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
