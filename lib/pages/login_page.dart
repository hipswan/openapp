import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/business_home.dart';
import 'package:openapp/pages/widgets/openapp_logo.dart';

import '../model/business.dart';
import '../model/customer.dart';
import '../model/user_controller.dart';
import '../utility/Network/network_connectivity.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

import '../utility/appurl.dart';

// Business? currentBusiness;
Customer? currentClient;

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  final emailId = TextEditingController(text: "");
  final password = TextEditingController(text: "");

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  onSubmitForm(context) async {
    Navigator.pushNamed(context, '/home');
  }

  Widget orDivider = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        const Center(
          child: Divider(
            indent: 5,
            endIndent: 5,
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Center(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: const Text(
              'OR',
            ),
          ),
        ),
      ],
    ),
  );

  Widget alreadyHaveAnAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '''Don't Have an Account? ''',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
              style: TextStyle(
                color: secondaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  siginUser() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        final response = await http.post(
          Uri.parse('${AppConstant.SIGNIN}'),
          body: {"emailId": emailId.text, "password": password.text},
        );
        if (response.statusCode == 201) {
          final parsedJson = json.decode(response.body);
          return parsedJson;
        } else {
          throw Exception('Failed to loging User');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(
            'OpenApp',
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
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
                onPressed: () {
                  //TODO: Loader shown
                  siginUser().then((value) {
                    Loader.hide();
                    if (value.containsKey('bName')) {
                      // currentBusiness = Business.fromJson(value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessHome(
                            emailId: emailId.text,
                            password: password.text,
                          ),
                        ),
                      );
                    } else {
                      currentClient = Customer.fromJson(value);

                      Navigator.pushNamed(context, '/home');
                    }
                  }).catchError((error) {
                    Loader.hide();
                    dev.log(error.toString());
                  });
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              const OpenappLogo(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: TextFormField(
                  controller: emailId,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: alreadyHaveAnAccount(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTile extends StatelessWidget {
  final icon;
  const LoginTile({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all(
          Colors.black,
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
        ),
        elevation: MaterialStateProperty.all(
          0.5,
        ),
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
      onPressed: () {},
      child: Icon(
        icon,
      ),
    );
  }
}
