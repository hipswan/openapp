import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openapp/pages/business_home.dart';
import 'package:openapp/pages/business_page.dart';
import 'package:openapp/pages/home_page.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/post_items.dart';
import 'package:openapp/pages/register_page.dart';
import 'package:openapp/pages/shop_page.dart';
import 'package:openapp/pages/type_selection.dart';
import 'package:openapp/pages/widgets/hex_color.dart';

import 'pages/widgets/custom_slider_rect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        primarySwatch: Colors.blue,
        bottomAppBarColor: Colors.blue,
      ).copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blue,
        secondaryHeaderColor: Colors.blue,
        sliderTheme: SliderThemeData(
          inactiveTrackColor: HexColor('#707070'),
          activeTrackColor: HexColor('#707070'),
          trackShape: RectangularSliderTrackShape(),
          trackHeight: 4.0,
          thumbShape: CustomSliderThumbRect(
            thumbHeight: 30.0,
            thumbRadius: 5.0,
          ),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
          overlayColor: HexColor('#FEC13C').withAlpha(50),
          thumbColor: Colors.white,
          tickMarkShape: RoundSliderTickMarkShape(),
          activeTickMarkColor: HexColor('#FEC13C'),
          inactiveTickMarkColor: Colors.white,
          valueIndicatorShape: RectangularSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.redAccent,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: SafeArea(
        child: TypeSelection(),
      ),
      routes: {
        '/shop': (context) => const ShopPage(),
        '/home': (context) => const HomePage(),
        '/seller_signup': (context) => const RegisterPage(),
        '/buyer_signup': (context) => LoginPage(),
        '/business_home': (context) => BusinessHome(),
        '/business': (context) => const BusinessPage(),
      },
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
