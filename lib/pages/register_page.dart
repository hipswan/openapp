import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:http/http.dart';
import 'package:openapp/controller/web3_controller.dart';
import 'package:openapp/pages/widgets/form_page.dart';
import 'package:web3dart/web3dart.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
CollectionReference sellerDetailsRef =
    FirebaseFirestore.instance.collection('sellerDetails');

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var currentStep = 0;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final shopName = TextEditingController();
  final account =
      TextEditingController(text: '0x059Ac2d11b1B59B1e66E23D885a8E3d6b3c5Ca63');
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
    final canContinue = currentStep < 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Registration',
        ),
        centerTitle: true,
      ),
      body: CupertinoStepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepTapped: (step) => setState(() => currentStep = step),
        onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
        onStepContinue: canContinue
            ? () async {
                if (currentStep == 0) {
                  setState(() => ++currentStep);
                } else if (currentStep == 1) {
                  final web3Controller = Web3Controller(
                      ethClient: Web3Client(
                        "https://ropsten.infura.io/v3/d51b8ae11bb34cdf9ecc3fc4b65cea07",
                        Client(),
                      ),
                      privateKey: EthPrivateKey.fromHex(
                          "0xfe6c8e3bfc0758bed739cb6f1594402db1be0f2301c781ba8403b1a713ba5f9c"));

                  DocumentSnapshot doc = await usersRef.doc(account.text).get();
                  if (!doc.exists) {
                    final response = await web3Controller.submit("UserReg",
                        ['${firstName.text} ${lastName.text}', BigInt.from(1)]);
                    await usersRef.doc(account.text).set({
                      'name': '${firstName.text} ${lastName.text}', // John Doe
                      'account': account.text, // Stokes and Sons

                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                      'userType': 'seller',
                      'transaction_hash': response.toString(),
                      // 42
                    });
                    await sellerDetailsRef.doc(account.text).set({
                      'daysOperating': daysOperating,
                      'shopName': shopName.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Seller Successfully Registered'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('''Seller's Account already exists'''),
                      ),
                    );
                  }
                }
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
                      controller: shopName,
                      decoration: InputDecoration(
                        labelText: 'Shop Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: account,
                      decoration: InputDecoration(
                        labelText: 'Account',
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
              isActive: 1 == currentStep,
              state: 1 == currentStep
                  ? StepState.editing
                  : 1 < currentStep
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
                              child: Center(child: Text('${element.key}'))),
                          selected: element.value['active'] as bool,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          selectedColor: Colors.blue,
                          onSelected: (bool selected) {
                            setState(() {
                              daysOperating[element.key]!['active'] = selected;
                              daysOperating[element.key]!['from'] = '00:00';
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
