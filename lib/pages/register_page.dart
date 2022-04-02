import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:openapp/pages/widgets/form_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var currentStep = 0;
  var fields = {
    'Personal Details': ['Email', 'Password', 'Confirm Password'],
    'Business Details': ['First Name', 'Last Name', 'Phone Number'],
    'Someother Details': ['Address', 'City', 'State', 'Zip Code']
  };

  @override
  Widget build(BuildContext context) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
        ),
        centerTitle: true,
      ),
      body: CupertinoStepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
          onStepContinue:
              canContinue ? () => setState(() => ++currentStep) : null,
          steps: List.generate(
              fields.length,
              (index) => _buildStep(
                    title: Text('${fields.keys.toList()[index]}'),
                    isActive: index == currentStep,
                    state: index == currentStep
                        ? StepState.editing
                        : index < currentStep
                            ? StepState.complete
                            : StepState.indexed,
                    content: FormPage(
                      fields: fields.values.toList()[index],
                    ),
                  ))
            ..add(
              _buildStep(
                title: Text('Error'),
                state: StepState.error,
              ),
            )
            ..add(
              _buildStep(
                title: Text('Disabled'),
                state: StepState.disabled,
              ),
            )),
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
