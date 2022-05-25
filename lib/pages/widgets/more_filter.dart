import 'package:flutter/material.dart';

import '../../constant.dart';

class MoreFilter extends StatefulWidget {
  const MoreFilter({Key? key}) : super(key: key);

  @override
  State<MoreFilter> createState() => _MoreFilterState();
}

class _MoreFilterState extends State<MoreFilter> {
  var _moreFitlers = [
    {
      'Good for kids': false,
    },
    {
      'Takeout': false,
    },
    {
      'Wheelchair accessible entrance': false,
    },
    {
      'Breakfast': false,
    },
    {
      'Brunch': false,
    },
    {
      'Delivery': false,
    },
    {
      'Dine-in': false,
    },
    {
      'Tourists': false,
    },
    {
      'Lunch': false,
    },
    {
      'Vegetarian options': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Filter'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Food & Entertainment',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 5,
                      spacing: 5,
                      children: List.generate(
                        _moreFitlers.length,
                        (index) {
                          var filter = _moreFitlers[index].keys.first;
                          return FilterChip(
                            key: ValueKey(index),
                            checkmarkColor: secondaryColor,
                            label: Text(filter),
                            selectedColor: thirdColor,
                            selected: _moreFitlers[index][filter]!,
                            shadowColor: secondaryColor,
                            elevation: 3,
                            onSelected: (bool value) {
                              setState(() {
                                _moreFitlers[index][filter] = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Food & Entertainment',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 5,
                      spacing: 5,
                      children: List.generate(
                        _moreFitlers.length,
                        (index) {
                          var filter = _moreFitlers[index].keys.first;
                          return FilterChip(
                            key: ValueKey(index),
                            checkmarkColor: secondaryColor,
                            label: Text(filter),
                            selectedColor: thirdColor,
                            selected: _moreFitlers[index][filter]!,
                            shadowColor: secondaryColor,
                            elevation: 3,
                            onSelected: (bool value) {
                              setState(() {
                                _moreFitlers[index][filter] = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Food & Entertainment',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 5,
                      spacing: 5,
                      children: List.generate(
                        _moreFitlers.length,
                        (index) {
                          var filter = _moreFitlers[index].keys.first;
                          return FilterChip(
                            key: ValueKey(index),
                            checkmarkColor: secondaryColor,
                            label: Text(filter),
                            selectedColor: thirdColor,
                            selected: _moreFitlers[index][filter]!,
                            shadowColor: secondaryColor,
                            elevation: 3,
                            onSelected: (bool value) {
                              setState(() {
                                _moreFitlers[index][filter] = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
