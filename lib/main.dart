import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/model/business.dart';
import 'package:openapp/pages/business/business_home.dart';
import 'package:openapp/pages/business/business_page.dart';
import 'package:openapp/pages/customer/client_map.dart';
import 'package:openapp/pages/customer/client_register.dart';
import 'package:openapp/pages/customer/home_page.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/post_items.dart';
import 'package:openapp/pages/business/business_register.dart';
import 'package:openapp/pages/shop_page.dart';
import 'package:openapp/pages/type_selection.dart';
import 'package:openapp/widgets/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.green,
        child: Center(
          child: Text(
            'OpenApp facing issue: ${details.toString()}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenApp',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(),
        primarySwatch: Colors.red,
        bottomAppBarColor: HexColor('#FCD2D1'),
      ).copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.red,
        secondaryHeaderColor: Colors.redAccent,
        colorScheme: ColorScheme.light(primary: Colors.redAccent),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: secondaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: secondaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            color: secondaryColor,
            fontSize: 18.0,
          ),
        ),
      ),
      home: SafeArea(
        child: TypeSelection(),
      ),
      routes: {
        '/shop': (context) => const ShopPage(),
        '/home': (context) => ClientMap(),
        '/client_register': ((context) => ClientRegister()),
        '/business_register': (context) => const BusinessRegister(),
        '/login': (context) => LoginPage(),
        // '/business_home': (context) => BusinessHome(),
        '/business': (context) => const BusinessPage(),
      },
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == '/post') {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PostItem(
                filePath: args,
              );
            },
          );
        }
      },
    );
  }
}
