import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart';
import 'package:openapp/widgets/form_page.dart';
import 'package:openapp/widgets/openapp_logo.dart';
import 'package:openapp/widgets/section.dart';
import 'package:openapp/utility/Network/network_connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:openapp/utility/appurl.dart';
import '../../constant.dart';
import 'dart:developer' as dev;

class BusinessRegister extends StatefulWidget {
  const BusinessRegister({Key? key}) : super(key: key);

  @override
  State<BusinessRegister> createState() => _BusinessRegisterState();
}

class _BusinessRegisterState extends State<BusinessRegister> {
  var currentStep = 0;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final businessName = TextEditingController();
  final businessCity = TextEditingController();
  final businessState = TextEditingController();
  final businessZip = TextEditingController();
  var businessCategory = null;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var daysOperating = {
    'Mon': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Tue': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Wed': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Thu': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Fri': {'active': false, 'from': '00:00', 'to': '00:00'},
    'Sat': {'active': false, 'from': '00:00', 'to': '00:00'},
  };

  Widget alreadyHaveAnAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
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
              text: 'Login In',
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
        textAlign: TextAlign.center,
      ),
    );
  }

  Future signupUser() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        final response =
            await http.post(Uri.parse('${AppConstant.BUSINESS_SIGNUP}'), body: {
          "user": {
            "firstName": firstName.text,
            "lastName": lastName.text,
            "phoneNumber": phoneNumber.text,
            "emailId": email.text,
          },
          "business": {
            "bName": businessName.text,
            "bCity": businessCity.text,
            "bState": businessState.text,
            "bType": businessCategory,
            "bZip": businessZip.text,
          },
          "businessHours": [],
          "staff": [],
          "businessServices": []
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
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 2;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => !Loader.isShown,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(
              'Register Business',
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: Scrollbar(
                  child: ListView(
                    children: [
                      OpenappLogo(),
                      CupertinoStepper(
                        type: StepperType.vertical,
                        currentStep: currentStep,
                        onStepTapped: (step) =>
                            setState(() => currentStep = step),
                        onStepCancel: canCancel
                            ? () => setState(() => --currentStep)
                            : null,
                        onStepContinue: canContinue
                            ? () async {
                                if (currentStep == 1) {
                                  if (_formKey.currentState!.validate()) {
                                    Loader.show(
                                      context,
                                      isSafeAreaOverlay: false,
                                      isBottomBarOverlay: false,
                                      overlayFromBottom: 80,
                                      overlayColor: Colors.black26,
                                      progressIndicator:
                                          CircularProgressIndicator(
                                              backgroundColor: Colors.red),
                                      themeData: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.fromSwatch()
                                            .copyWith(secondary: Colors.green),
                                      ),
                                    );

                                    signupUser().then((value) {
                                      // Navigator.pushNamedAndRemoveUntil(context,
                                      //     '/business_home', (route) => false);
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text('Business Created'),
                                                content: Text(
                                                    'Connect with us today Thank you for helping us with the information.Your application is under review. We will send you an email with your login credentials once it is processed.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context, '/login');
                                                    },
                                                  )
                                                ],
                                              ));
                                    }).catchError((e) {
                                      Loader.hide();
                                      dev.log(
                                        e.toString(),
                                      );
                                    });
                                  }
                                } else
                                  setState(
                                    () => ++currentStep,
                                  );
                              }
                            : null,
                        steps: [
                          _buildStep(
                            title: Text(
                              'Personal Details',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            isActive: 0 == currentStep,
                            state: 0 == currentStep
                                ? StepState.editing
                                : 0 < currentStep
                                    ? StepState.complete
                                    : StepState.indexed,
                            subtitle: 'Enter your personal details',
                            content: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: firstName,
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: lastName,
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: email,
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Please enter your email';
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: phoneNumber,
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Please enter your phone number';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildStep(
                            title: Text(
                              'Business Details',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            isActive: 1 == currentStep,
                            state: 1 == currentStep
                                ? StepState.editing
                                : 1 < currentStep
                                    ? StepState.complete
                                    : StepState.indexed,
                            subtitle: 'Enter your business details',
                            content: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: businessName,
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Please enter your business name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Business Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: DropdownButtonFormField<String>(
                                    value: businessCategory,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter business type';
                                      }
                                      return null;
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          child: Text('Restaurant'),
                                          value: 'Restaurant'),
                                      DropdownMenuItem(
                                          child: Text('Salon'), value: 'Salon'),
                                      DropdownMenuItem(
                                          child: Text('Clinic'),
                                          value: 'Clinic'),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        businessCategory = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Select Category',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: businessState,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter state, city';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'State, City',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: businessZip,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter zip code';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Zip/Postal Code',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: alreadyHaveAnAccount(
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Step _buildStep({
    required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
    content = const SizedBox(),
    subtitle = 'Subtitle',
  }) {
    return Step(
      title: title,
      subtitle: Text(
        '$subtitle',
        style: TextStyle(
          color: secondaryColor,
          fontSize: 14,
        ),
      ),
      state: state,
      isActive: isActive,
      content: content,
    );
  }
}
