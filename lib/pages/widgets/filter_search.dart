import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../constant.dart';
import 'dart:developer' as dev;

class FilterSearch extends StatefulWidget {
  const FilterSearch({Key? key}) : super(key: key);

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  var _sortBy = [true, false, false];
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filter'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        bottomSheet: Container(
          width: double.infinity,
          color: secondaryColor,
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    thirdColor,
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 139, 88, 6),
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              //Relevance
              FilterSortBy(),
              Text(
                'Price',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              //Price
              FilterPrice(),
              Text(
                'Ratings',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              //Rating
              FilterRating(),
              Text(
                'Hours',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              //Hours
              FilterHour(),
              //More Filters
              Text(
                'More Filters',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
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
                  children: List.generate(_moreFitlers.length, (index) {
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
                  }),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilterHour extends StatelessWidget {
  const FilterHour({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: 75.0,
          fontSize: 16.0,
          initialLabelIndex: 1,
          cornerRadius: 20.0,
          borderWidth: 2.0,
          borderColor: [secondaryColor],
          activeBgColor: [thirdColor],
          activeFgColor: Color.fromARGB(255, 139, 88, 6),
          inactiveBgColor: Colors.white,
          inactiveFgColor: Colors.grey[900],
          totalSwitches: 3,
          labels: ['Any', 'Open Now', 'Custom'],
          onToggle: (index) {
            dev.log('switched to: $index');
          },
        ),
      ),
    );
  }
}

class FilterRating extends StatelessWidget {
  const FilterRating({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: 75.0,
          fontSize: 16.0,
          initialLabelIndex: 1,
          cornerRadius: 20.0,
          borderWidth: 2.0,
          borderColor: [secondaryColor],
          activeBgColor: [thirdColor],
          activeFgColor: Color.fromARGB(255, 139, 88, 6),
          inactiveBgColor: Colors.white,
          inactiveFgColor: Colors.grey[900],
          totalSwitches: 4,
          labels: ['Any', '3.5 ⭐️', '4.0 ⭐️', '4.5 ⭐️'],
          onToggle: (index) {
            dev.log('switched to: $index');
          },
        ),
      ),
    );
  }
}

class FilterPrice extends StatelessWidget {
  const FilterPrice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: 75.0,
          fontSize: 16.0,
          initialLabelIndex: 1,
          cornerRadius: 20.0,
          borderWidth: 2.0,
          borderColor: [secondaryColor],
          activeBgColor: [thirdColor],
          activeFgColor: Color.fromARGB(255, 139, 88, 6),
          inactiveBgColor: Colors.white,
          inactiveFgColor: Colors.grey[900],
          totalSwitches: 4,
          labels: ['\$', '\$\$', '\$\$\$', '\$\$\$\$'],
          onToggle: (index) {
            dev.log('switched to: $index');
          },
        ),
      ),
    );
  }
}

class FilterSortBy extends StatelessWidget {
  const FilterSortBy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: 75.0,
          fontSize: 16.0,
          initialLabelIndex: 1,
          cornerRadius: 20.0,
          borderWidth: 2.0,
          borderColor: [secondaryColor],
          activeBgColor: [thirdColor],
          activeFgColor: Color.fromARGB(255, 139, 88, 6),
          inactiveBgColor: Colors.white,
          inactiveFgColor: Colors.grey[900],
          totalSwitches: 3,
          labels: ['Relevance', 'Distance', 'Your Match'],
          onToggle: (index) {
            dev.log('switched to: $index');
          },
        ),
      ),
    );
  }
}
