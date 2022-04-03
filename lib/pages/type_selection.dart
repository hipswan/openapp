import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:openapp/constant.dart';

class TypeSelection extends StatefulWidget {
  const TypeSelection({Key? key}) : super(key: key);

  @override
  State<TypeSelection> createState() => _TypeSelectionState();
}

class _TypeSelectionState extends State<TypeSelection> {
  var _value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Wrap(
            spacing: 20.0,
            direction: Axis.vertical,
            children: [
              ChoiceChip(
                labelPadding: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                labelStyle: homePageTextStyle,
                selectedColor: Colors.blue,
                selectedShadowColor: Colors.blue,
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: const Text('B'),
                ),
                label: Text('Buyer'),
                selected: _value == 0,
                onSelected: (bool selected) {
                  setState(() {
                    _value = (selected ? 0 : null)!;
                  });
                },
              ),
              ChoiceChip(
                labelPadding: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                selectedColor: Colors.blue,
                labelStyle: homePageTextStyle,
                selectedShadowColor: Colors.blue,
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: const Text('S'),
                ),
                label: Text('Seller'),
                selected: _value == 1,
                onSelected: (bool selected) {
                  setState(
                    () {
                      _value = (selected ? 1 : null)!;
                    },
                  );
                },
              )
            ],
          )),
          Positioned(
            right: 20,
            bottom: 30,
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                if (_value == 0) {
                  Navigator.of(context).pushNamed('/buyer_signup');
                } else if (_value == 1) {
                  Navigator.of(context).pushNamed('/seller_signup');
                }
              },
              child: Container(
                width: 70,
                height: 70,
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
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
