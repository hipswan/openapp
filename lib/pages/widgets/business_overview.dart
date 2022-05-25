import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:share_plus/share_plus.dart';

class BusinessOverview extends StatefulWidget {
  const BusinessOverview({Key? key}) : super(key: key);

  @override
  State<BusinessOverview> createState() => _BusinessOverviewState();
}

class _BusinessOverviewState extends State<BusinessOverview> {
  static const cleaningAndSanitization = [
    'Surfaces sanitized between seatings',
    'Common areas deep cleaned daily',
    'Sanitizer or wipes provided for customers',
    'Contactless payment available',
  ];
  static const staffScreening = [
    'Sick staff prohibited in the workplace',
    'Staff temperature check required',
    'Staff is vaccinated',
    'Waitstaff wear masks',
  ];
  Widget _animatedOpenHours = Text(
    'Open Hours',
  );
  var dayData = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Text(
            'Business Name',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: SizedBox(
            height: 150,
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              scrollDirection: Axis.horizontal,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  child: Container(
                    width: 150,
                    color: Colors.brown,
                    child: FlutterLogo(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Text(
            'category',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Text(
            'Open: Closes 7pm',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            children: [
              ActionChip(
                avatar: Icon(
                  Icons.call,
                ),
                label: Text(
                  'Call',
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 10.0,
              ),
              ActionChip(
                onPressed: () {},
                avatar: Icon(
                  Icons.directions,
                ),
                label: Text(
                  'Directions',
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              ActionChip(
                onPressed: () {
                  Share.share('check out my website https://openapp.com',
                      subject: 'Look what I made!');
                },
                avatar: Icon(
                  Icons.share,
                ),
                label: Text(
                  'Share',
                ),
              ),
            ],
          ),
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          leading: Icon(
            Icons.location_on_outlined,
            color: secondaryColor,
          ),
          title: Text('Address'),
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          onTap: () async {
            await Future.delayed(Duration(milliseconds: 100));
            setState(() {
              if (_animatedOpenHours is Text)
                _animatedOpenHours = Column(
                  children: List.generate(7, (index) {
                    var dateToday = DateTime.now();
                    var currWeekNumber = dateToday.weekday;
                    var weekNumber = (index) + currWeekNumber;
                    if (weekNumber > 7) weekNumber = weekNumber - 7;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dayData[weekNumber]!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: currWeekNumber == weekNumber
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            '8:00 - 17:00',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: currWeekNumber == weekNumber
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              else {
                _animatedOpenHours = Text(
                  'Open Hours',
                );
              }
            });
          },
          leading: Icon(
            Icons.watch_later_outlined,
            color: secondaryColor,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: Duration(
                  milliseconds: 200,
                ),
                child: _animatedOpenHours,
                transitionBuilder: (child, _animation) => ScaleTransition(
                  child: child,
                  scale: _animation,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          leading: Icon(
            Icons.clean_hands_rounded,
            color: secondaryColor,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cleaning & Sanitizing',
                ),
                Wrap(
                  spacing: 2,
                  children: cleaningAndSanitization
                      .map(
                        (item) => Chip(
                          backgroundColor: thirdColor,
                          avatar: Icon(
                            Icons.check,
                          ),
                          label: Text(
                            item,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          leading: Icon(
            Icons.health_and_safety_outlined,
            color: secondaryColor,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Staff Cleaning',
                ),
                Wrap(
                  spacing: 2,
                  children: staffScreening
                      .map(
                        (item) => Chip(
                          backgroundColor: thirdColor,
                          avatar: Icon(
                            Icons.check,
                          ),
                          label: Text(
                            item,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
