import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:openapp/pages/widgets/form_page.dart';
import 'package:openapp/pages/widgets/openapp_logo.dart';

import '../constant.dart';

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
  final businessLocation = TextEditingController();

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 2;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(
            'Business',
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: ListView(
          children: [
            OpenappLogo(),
            Theme(
              data: Theme.of(context).copyWith(),
              child: CupertinoStepper(
                type: StepperType.vertical,
                currentStep: currentStep,
                onStepTapped: (step) => setState(() => currentStep = step),
                onStepCancel:
                    canCancel ? () => setState(() => --currentStep) : null,
                onStepContinue: canContinue
                    ? () async {
                        if (currentStep == 1) {
                          Navigator.pushNamed(context, '/business_home');
                        } else
                          setState(() => ++currentStep);
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
                    content: Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: firstName,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: lastName,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: phoneNumber,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildStep(
                    title: Text('Business Details'),
                    isActive: 1 == currentStep,
                    state: 1 == currentStep
                        ? StepState.editing
                        : 1 < currentStep
                            ? StepState.complete
                            : StepState.indexed,
                    subtitle: 'Enter your business details',
                    content: Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: firstName,
                              decoration: InputDecoration(
                                labelText: 'Business Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: DropdownButtonFormField(
                              items: [
                                DropdownMenuItem(
                                    child: Text('Restaurant'),
                                    value: 'Restaurant'),
                                DropdownMenuItem(
                                    child: Text('Salon'), value: 'Salon'),
                                DropdownMenuItem(
                                    child: Text('Clinic'), value: 'Clinic'),
                              ],
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                labelText: 'Select Category',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: businessLocation,
                              decoration: InputDecoration(
                                labelText: 'State, City',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: phoneNumber,
                              decoration: InputDecoration(
                                labelText: 'Zip/Postal Code',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: alreadyHaveAnAccount(context),
            ),
            SizedBox(
              height: 30,
            ),
          ],
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
      subtitle: Text('$subtitle'),
      state: state,
      isActive: isActive,
      content: content,
    );
  }
}
