import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:openapp/controller/web3_controller.dart';
import 'package:openapp/pages/widgets/openapp_logo.dart';
import 'package:web3dart/web3dart.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

User? currentUser;
Web3Client web3Client = Web3Client(
  "https://ropsten.infura.io/v3/d51b8ae11bb34cdf9ecc3fc4b65cea07",
  Client(),
);
EthPrivateKey cred = EthPrivateKey.fromHex(
    "0xfe6c8e3bfc0758bed739cb6f1594402db1be0f2301c781ba8403b1a713ba5f9c");
final web3Controller = Web3Controller(ethClient: web3Client, privateKey: cred);

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  var userType = UserType.buyer.index;
  final name = TextEditingController(text: "Atul Singh");
  final emailId = TextEditingController(text: "atulsingh158@gmail.com");
  final password = TextEditingController(text: "Iceage@123");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final account =
      TextEditingController(text: "0x059Ac2d11b1B59B1e66E23D885a8E3d6b3c5Ca63");

  onSubmitForm(context, CollectionReference usersRef) async {
    if (_formKey.currentState!.validate()) {
      DocumentSnapshot doc = await usersRef.doc(account.text).get();
      if (!doc.exists) {
        final response = await web3Controller
            .submit("UserReg", [name.text, BigInt.from(userType)]);
        await usersRef.doc(account.text).set({
          'name': name.text, // John Doe
          'account': account.text, // Stokes and Sons
          'emailId': emailId.text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'userType': userType == 0 ? 'buyer' : 'seller',
          'transaction_hash': response.toString(),
          // 42
        });

        currentUser = User.fromDocument(doc);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Registered'),
          ),
        );
      } else {
        currentUser = User.fromDocument(doc);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Account already registered as ${(doc.data() as Map)['userType']}'),
          ),
        );
      }

      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: ListView(
              children: [
                const OpenappLogo(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: emailId,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: account,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Account',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SignInButton(
                    Buttons.FacebookNew,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SignInButton(
                    Buttons.Apple,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22.0,
                    horizontal: 8.0,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: 'have an account? ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: GestureDetector(
              onTap: () async {
                await onSubmitForm(context, usersRef);
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
