import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openapp/pages/business_home.dart';
import 'package:openapp/pages/business_page.dart';
import 'package:openapp/pages/client_map.dart';
import 'package:openapp/pages/client_register.dart';
import 'package:openapp/pages/home_page.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/post_items.dart';
import 'package:openapp/pages/business_register.dart';
import 'package:openapp/pages/shop_page.dart';
import 'package:openapp/pages/type_selection.dart';
import 'package:openapp/pages/widgets/hex_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/business_home': (context) => BusinessHome(),
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
