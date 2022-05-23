import 'package:flutter/material.dart';

import '../business_profile.dart';
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
                    child: Image.asset(
                      'assets/images/drawer.png',
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                      color: Colors.redAccent,
                      // colorBlendMode: BlendMode.plus,
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
                              width: 5.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: Image.asset(
                              'assets/images/businessBack2.jpg',
                            ).image,
                            radius: 50.0,
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
                                'Business Name',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '{location}',
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
            text: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusinessProfile(),
                ),
              );
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
