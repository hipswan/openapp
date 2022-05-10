import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:http/http.dart';
import 'package:openapp/pages/widgets/form_page.dart';
import 'package:openapp/pages/widgets/openapp_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var currentStep = 0;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Registration',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          OpenappLogo(),
          Expanded(
            child: CupertinoStepper(
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepTapped: (step) => setState(() => currentStep = step),
              onStepCancel:
                  canCancel ? () => setState(() => --currentStep) : null,
              onStepContinue: canContinue
                  ? () async {
                      if (currentStep == 2) {
                        Navigator.pushNamed(context, '/business');
                      } else
                        setState(() => ++currentStep);
                    }
                  : null,
              steps: [
                _buildStep(
                  title: Text('Personal Details'),
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
                            controller: password,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                              labelText: 'Name of Business',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: businessName,
                            decoration: InputDecoration(
                              labelText: 'phone number',
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
                            controller: password,
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
                _buildStep(
                    title: Text('Business Operating Hours'),
                    isActive: 2 == currentStep,
                    state: 2 == currentStep
                        ? StepState.editing
                        : 2 < currentStep
                            ? StepState.complete
                            : StepState.indexed,
                    subtitle: 'Enter your business operating hours',
                    content: Wrap(
                      children: daysOperating.entries.map((element) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: SizedBox(
                                    height: 20,
                                    width: 35,
                                    child:
                                        Center(child: Text('${element.key}'))),
                                selected: element.value['active'] as bool,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                selectedColor: Colors.blue,
                                onSelected: (bool selected) {
                                  setState(() {
                                    daysOperating[element.key]!['active'] =
                                        selected;
                                    daysOperating[element.key]!['from'] =
                                        '00:00';
                                    daysOperating[element.key]!['to'] = '00:00';
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: element.value['from'] as String),
                                  enabled: element.value['active'] as bool,
                                  keyboardType: TextInputType.none,
                                  onTap: () async {
                                    await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      setState(() {
                                        daysOperating[element.key]!['from'] =
                                            '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: element.value['to'] as String),
                                  enabled: element.value['active'] as bool,
                                  keyboardType: TextInputType.none,
                                  onTap: () async {
                                    await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      setState(() {
                                        daysOperating[element.key]!['to'] =
                                            '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),
        ],
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
