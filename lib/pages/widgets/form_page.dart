import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  final fields;
  FormPage({
    Key? key,
    required this.fields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
            children: List.generate(
          fields.length,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: fields[index],
                border: OutlineInputBorder(),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
