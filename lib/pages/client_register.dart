import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/widgets/openapp_logo.dart';
import 'package:http/http.dart' as http;
import '../model/user_controller.dart';
import '../utility/Network/network_connectivity.dart';
import '../utility/appurl.dart';

class ClientRegister extends StatelessWidget {
  ClientRegister({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController(text: "Atul Singh");
  final emailId = TextEditingController(text: "atulsingh158@gmail.com");
  final password = TextEditingController(text: "Iceage@123");
  final phone = TextEditingController(text: "7166179315");

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
              text: '''Already Have an Account? ''',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Login in',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/login');
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

  sigupUser() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        final response =
            await http.post(Uri.parse('${AppConstant.SIGNUP}'), body: {
          "emailId": emailId.text,
          "password": password.text,
          "firstname": name.text,
          "lastName": "",
          "phoneNumber": phone.text
        });
        if (response.statusCode == 200) {
        } else {
          throw Exception('Failed to create business');
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
            'Customer',
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Loader.show(
                      context,
                      isSafeAreaOverlay: false,
                      isBottomBarOverlay: false,
                      overlayFromBottom: 80,
                      overlayColor: Colors.black26,
                      progressIndicator: CircularProgressIndicator(
                          backgroundColor: Colors.red),
                      themeData: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.green),
                      ),
                    );

                    try {
                      await sigupUser();
                      Loader.hide();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/business_home', (route) => false);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text(
                  'Sign Up',
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
                  controller: name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
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
                  controller: emailId,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length != 10) {
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
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
