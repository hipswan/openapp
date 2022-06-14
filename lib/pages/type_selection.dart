import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/main.dart';
import 'package:openapp/widgets/hex_color.dart';

class TypeSelection extends StatefulWidget {
  const TypeSelection({Key? key}) : super(key: key);

  @override
  State<TypeSelection> createState() => _TypeSelectionState();
}

class _TypeSelectionState extends State<TypeSelection> {
  var _value = 0;

  Widget alreadyHaveAnAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '''Already Have an Account? ''',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Login In',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/login');
                },
              style: TextStyle(
                color: thirdColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/icons/calendar_circle_big.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.4),
                    ],
                    tileMode: TileMode.clamp,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        'OpenApp',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: thirdColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        'OpenApp is a platform for businesses to connect with their customers and customers to businesses.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        'register as a business or as a customer',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Row(
                        children: [
                          ChoiceChip(
                            labelPadding: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            labelStyle: homePageTextStyle,
                            selectedColor: Colors.redAccent,
                            selectedShadowColor: Colors.grey,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                'B',
                                style: TextStyle(
                                  color: thirdColor,
                                ),
                              ),
                            ),
                            label: Text('Business'),
                            selected: _value == 0,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = (selected ? 0 : null)!;
                              });
                            },
                          ),
                          Spacer(),
                          ChoiceChip(
                            labelPadding: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            selectedColor: Colors.redAccent,
                            labelStyle: homePageTextStyle,
                            selectedShadowColor: Colors.blue,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                'C',
                                style: TextStyle(
                                  color: thirdColor,
                                ),
                              ),
                            ),
                            label: Text('Customer'),
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
                      ),
                    ),
                    alreadyHaveAnAccount(context),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: FloatingActionButton(
                          onPressed: () async {
                            // Navigator.of(context).pop();
                            if (_value == 0) {
                              await prefs?.setInt('userType', _value);
                              Navigator.of(context)
                                  .pushNamed('/business_register');
                            } else if (_value == 1) {
                              await prefs?.setInt('userType', _value);
                              Navigator.of(context)
                                  .pushNamed('/client_register');
                            }
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          backgroundColor: HexColor('#143F6B'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
