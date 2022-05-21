import 'dart:ffi';

import 'package:flutter/material.dart';

import 'hex_color.dart';

class InfoWall extends StatefulWidget {
  const InfoWall({Key? key}) : super(key: key);

  @override
  State<InfoWall> createState() => _InfoWallState();
}

class _InfoWallState extends State<InfoWall> {
  var isEditing = false;
  final _businessCategory = [
    'Auto Shop',
    'Beauty Salon',
  ];
  var _daysOperating = {
    'Mon': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Tue': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Wed': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Thu': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Fri': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Sat': {'active': false, 'from': '00:00', 'to': '00:00'},
  };

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    Widget bottomBox = Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Colors.transparent,
        //     Colors.white.withOpacity(0.5),
        //     Colors.white,
        //   ],
        //   stops: const [
        //     0.3,
        //     0.3,
        //     0.5,
        //   ],
        // ),
      ),
      child: Container(
        height: 50,
        width: 100,
        padding: const EdgeInsets.all(
          10.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(
            10,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(
                    0.3,
                  ),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Edit Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );

    List<Widget> businessInfo = <Widget>[
      Text(
        'Business Info',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              enabled: isEditing,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                labelText: 'First',
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: TextField(
              enabled: isEditing,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                labelText: 'Last',
              ),
            ),
          ),
        ],
      ),
      TextField(
        enabled: isEditing,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Username/email',
        ),
      ),
      TextField(
        enabled: isEditing,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Mobile',
        ),
      ),
      TextField(
        enabled: isEditing,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
      ),
      TextField(
        enabled: isEditing,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Business Name',
        ),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              enabled: isEditing,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                labelText: 'Business City',
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),

          // Spacer(),
          Expanded(
            child: TextField(
              enabled: isEditing,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                labelText: 'Business State',
              ),
            ),
          ),
        ],
      ),
      TextField(
        enabled: isEditing,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Business Zip/Postal Code',
        ),
      ),
      DropdownButtonFormField(
        items: _businessCategory
            .map<DropdownMenuItem<String>>(
              (category) => DropdownMenuItem(
                child: Text(category),
                value: category,
              ),
            )
            .toList(),
        onChanged: isEditing ? (value) {} : null,
        decoration: InputDecoration(
          labelText: 'Select Business Category',
        ),
      ),
      SizedBox(
        height: 34.0,
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#143F6B'),
        onPressed: () async {
          // Navigator.pushNamed(context, '/staff_add');

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
      body: Container(
        height: maxHeight,
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.0,
                24.0,
                20.0,
                0.0,
              ),
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
                                  child: Center(child: Text('${element.key}'))),
                              selected: element.value['active'] as bool,
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              selectedColor: Colors.blue,
                              onSelected: (bool selected) {
                                isEditing
                                    ? setState(() {
                                        _daysOperating[element.key]!['active'] =
                                            selected;
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
                                            _daysOperating[element.key]!['to'] =
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
            ),
          ],
        ),
      ),
    );
  }
}
