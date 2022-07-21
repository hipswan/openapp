import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/business/business_details.dart';
import 'package:openapp/pages/business/business_home.dart';
import 'package:openapp/pages/customer/client_home.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  PageController pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (value) => setState(() => currentPage = value),
        controller: pageController,
        children: <Widget>[
          ClientMap(),
          BusinessHome(),
          //TODO: Add Profile Page
          Container(
            color: Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) async {
          await pageController.animateToPage(
            value,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        selectedItemColor: secondaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: "Appointment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
