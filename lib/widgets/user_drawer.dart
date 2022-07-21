import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/business/business_register.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/widgets/form/business_form.dart';

import '../../utility/appurl.dart';
import '../pages/business/business_home.dart';
import '../pages/business/business_profile.dart';
import 'drawer_menu.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                30.0,
              ),
            ),
            child: Container(
              height: 170.0,
              width: 304.0,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                      child: Image.asset(
                        'assets/images/icons/calendar_circle.png',
                        color: Colors.black54,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 22.0,
                      top: 30.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            child: Text(
                              '${currentCustomer?.firstname?.substring(0, 1).toUpperCase()}',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: secondaryColor,
                            radius: 32.0,
                          ),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentCustomer?.email ?? ""}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${currentCustomer?.role ?? ""}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          DrawerMenu(
            text: 'About Us',
            onPressed: () {},
          ),
          Divider(
            thickness: 2.0,
            height: 1.0,
            indent: 22.0,
            endIndent: 22.0,
          ),
          DrawerMenu(
            text: 'Business',
            onPressed: () {
              if (currentCustomer?.role?.contains('business') ?? false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessProfile(),
                  ),
                );
              } else if (currentCustomer?.businessRequested ?? false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessRequested(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessForm(),
                  ),
                );
              }
            },
          ),
          Divider(
            thickness: 2.0,
            height: 1.0,
            indent: 22.0,
            endIndent: 22.0,
          ),
          DrawerMenu(
            text: 'Share with others',
            onPressed: () {},
          ),
          Divider(
            thickness: 2.0,
            height: 1.0,
            indent: 22.0,
            endIndent: 22.0,
          ),
          DrawerMenu(
            text: 'Rate the App',
            onPressed: () {},
          ),
          Divider(
            thickness: 2.0,
            height: 1.0,
            indent: 22.0,
            endIndent: 22.0,
          ),
          DrawerMenu(text: 'Privacy Policy', onPressed: () {}),
          Divider(
            thickness: 2.0,
            height: 1.0,
            indent: 22.0,
            endIndent: 22.0,
          ),
          DrawerMenu(text: 'Logout', onPressed: () {}),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }
}

class BusinessRequested extends StatelessWidget {
  const BusinessRequested({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Requested'),
      ),
      body: Center(
        child: Text('Business Requested'),
      ),
    );
  }
}
