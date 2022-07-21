import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:openapp/model/business.dart';
import 'package:openapp/model/business_appoitnment.dart';
import 'package:openapp/widgets/appointment_editor.dart';
import 'package:openapp/widgets/custom_animated_navigation_bar.dart';
import 'package:openapp/widgets/hex_color.dart';
import 'package:openapp/widgets/user_drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:developer' as dev;
import '../../utility/Network/network_connectivity.dart';
import '../../utility/appurl.dart';
import '../login_page.dart';
import 'business_staff.dart';
import 'package:http/http.dart' as http;

Business? currentBusiness;

class BusinessHome extends StatefulWidget {
  const BusinessHome({Key? key}) : super(key: key);

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  late List<String> _subjectCollection;
  late List<Appointment> _appointments;
  late List<Appointment> _appointments2;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Color> _colorCollection;
  late List<String> _colorNames;
  Color _inactiveColor = Colors.white;
  int _selectedColorIndex = 0;
  late List<DateTime> _visibleDates;
  int _currentIndex = 1;
  late _DataSource _events;
  Appointment? _selectedAppointment;
  bool _isAllDay = false;
  String _subject = '';
  final ScrollController controller = ScrollController();
  final CalendarController calendarController = CalendarController();
  bool hideEmptyScheduleWeek = false;

  bool allowDragAndDrop = false;

  String _loadingStatus = 'Loading...';

  Business _business = Business();

  /// Global key used to maintain the state,
  /// when we change the parent of the widget
  final GlobalKey _globalKey = GlobalKey();
  CalendarView _view = CalendarView.schedule;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.week,
    CalendarView.day,
    CalendarView.month,
    CalendarView.schedule
  ];

  @override
  void initState() {
    calendarController.view = _view;
    // getBusinessDetails();
    _appointments2 = _getAppointmentDetails();
    // _events = _DataSource(_appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _subject = '';
    super.initState();
  }

  Future<List<BusinessAppointment>> getBusinessAppoitnment() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var url = AppConstant.USER_BOOKINGS;
        final response = await http.get(Uri.parse('$url'),
            headers: {'x-auth-token': '${currentCustomer?.token}'});
        if (response.statusCode == 200) {
          var parsedJson = json.decode(response.body);
          return parsedJson.map<BusinessAppointment>((json) {
            return BusinessAppointment.fromJson(json);
          }).toList();
        } else {
          throw Exception('Failed to logging in business');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  /// Returns the month name based on the month value passed from date.
  String _getMonthDate(int month) {
    if (month == 01) {
      return 'January';
    } else if (month == 02) {
      return 'February';
    } else if (month == 03) {
      return 'March';
    } else if (month == 04) {
      return 'April';
    } else if (month == 05) {
      return 'May';
    } else if (month == 06) {
      return 'June';
    } else if (month == 07) {
      return 'July';
    } else if (month == 08) {
      return 'August';
    } else if (month == 09) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';
    }
  }

  /// Returns the builder for schedule view.
  Widget scheduleViewBuilder(
      BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
    final String monthName = _getMonthDate(details.date.month);
    return Stack(
      children: <Widget>[
        Image(
            image:
                ExactAssetImage('assets/images/calendar/' + monthName + '.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            monthName + ' ' + details.date.year.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _calendar({_DataSource? events}) {
      // _events = _DataSource(_appointments2);
      return Theme(
        /// The key set here to maintain the state,
        ///  when we change the parent of the widget

        key: _globalKey,
        data: ThemeData().copyWith(
            colorScheme:
                ThemeData().colorScheme.copyWith(secondary: Colors.blue)),
        child: _getAppointmentEditorCalendar(calendarController, _events,
            _onCalendarTapped, _onViewChanged, scheduleViewBuilder),
      );
    }

    final double _screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: UserDrawer(),
        appBar: AppBar(
          title: Text('Appointment'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: FutureBuilder<List<BusinessAppointment>>(
            future: getBusinessAppoitnment(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _events = _DataSource(getBusinessAppointments(snapshot.data));

                return calendarController.view == CalendarView.month
                    ? Scrollbar(
                        thumbVisibility: true,
                        controller: controller,
                        child: ListView(
                          controller: controller,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              height: 600,
                              child: _calendar(events: _events),
                            )
                          ],
                        ))
                    : Container(
                        color: Colors.white,
                        child: _calendar(
                          events: _events,
                        ),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#143F6B'),
          onPressed: () => {
            if (_view == CalendarView.schedule)
              {
                setState(() {
                  hideEmptyScheduleWeek = !hideEmptyScheduleWeek;
                })
              }
            else
              {
                setState(
                  () {
                    calendarController.view = CalendarView.week;

                    allowDragAndDrop = !allowDragAndDrop;
                  },
                )
              }
          },
          child: Icon(
            _view == CalendarView.schedule
                ? !hideEmptyScheduleWeek
                    ? Icons.calendar_view_day_rounded
                    : Icons.calendar_view_day_outlined
                : allowDragAndDrop
                    ? Icons.save_as_rounded
                    : Icons.edit_calendar_outlined,
            color: Colors.white,
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  List<Appointment> getBusinessAppointments(
      List<BusinessAppointment>? businessAppointments) {
    final List<Appointment> _appointments = <Appointment>[];
    if (businessAppointments != null && businessAppointments.isEmpty) {
      return _appointments;
    }
    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    final Random random = Random();

    for (BusinessAppointment appointment in businessAppointments!) {
      _appointments.add(Appointment(
        startTime: appointment.startTime ?? DateTime.now(),
        endTime: appointment.endTime ?? DateTime.now(),
        color: _colorCollection[random.nextInt(9)],
        startTimeZone: '',
        location:
            '${appointment.business?.phone ?? ""}@${appointment.service?.location?.formattedAddress ?? ""}@${appointment.id ?? ""}',
        endTimeZone: '',
        notes: '${appointment.note ?? ""}',
        isAllDay: false,
        subject:
            '${appointment.service?.name ?? "SERVICE-NAME"} @ ${appointment.business?.name ?? "SERVICE-NAME"}',
      ));
    }

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');
    return _appointments;
  }

  /// Creates the required appointment details as a list, and created the data
  /// source for calendar with required information.
  List<Appointment> _getAppointmentDetails() {
    final List<Appointment> appointmentCollection = <Appointment>[];
    _subjectCollection = <String>[];
    _subjectCollection.add('Tattoo Removal');
    _subjectCollection.add('Haircut');
    _subjectCollection.add('Medical appointment');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Therapy');
    _subjectCollection.add('Restaurant');
    _subjectCollection.add('Doctor');
    _subjectCollection.add('Pet Care');
    _subjectCollection.add('Performance Check');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    final DateTime today = DateTime.now();
    final Random random = Random();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          appointmentCollection.add(Appointment(
            startTime: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour)),
            endTime: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour + 2)),
            color: _colorCollection[random.nextInt(9)],
            startTimeZone: '',
            endTimeZone: '',
            notes: '',
            isAllDay: false,
            subject: _subjectCollection[random.nextInt(7)],
          ));
        }
      }
    }

    return appointmentCollection;
  }

  Widget getBody() {
    final Widget _calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: ThemeData().copyWith(
            colorScheme:
                ThemeData().colorScheme.copyWith(secondary: Colors.blue)),
        child: _getAppointmentEditorCalendar(calendarController, _events,
            _onCalendarTapped, _onViewChanged, scheduleViewBuilder));
    final double _screenHeight = MediaQuery.of(context).size.height;

    List<Widget> pages = [
      Container(),
      calendarController.view == CalendarView.month
          ? Scrollbar(
              thumbVisibility: true,
              controller: controller,
              child: ListView(
                controller: controller,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 600,
                    child: _calendar,
                  )
                ],
              ))
          : Container(
              color: Colors.white,
              child: _calendar,
            ),
      BusinessStaff(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(
        () => _currentIndex = index,
      ),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(
            Icons.room_service_rounded,
          ),

          //  SvgPicture.asset(
          //   'assets/vectors/people.svg',
          // ),
          title: Text(
            'Services ',
          ),
          activeColor: Colors.white,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.home,
          ),

          // SvgPicture.asset(
          //     'assets/vectors/home.svg',
          //   ),
          title: Text(
            'Home',
          ),
          activeColor: Colors.white,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.supervised_user_circle_outlined,
          ),

          // SvgPicture.asset(
          //   'assets/vectors/magnifying-glass.svg',
          // ),
          title: Text('Staff'),
          activeColor: Colors.white,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Returns the calendar based on the properties passed.
  SfCalendar _getAppointmentEditorCalendar(
      [CalendarController? _calendarController,
      CalendarDataSource? _calendarDataSource,
      dynamic calendarTapCallback,
      ViewChangedCallback? viewChangedCallback,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
        controller: _calendarController,
        //TODO:show navigation arrows in the calendar set to false
        showNavigationArrow: false,
        allowedViews: _allowedViews,
        showDatePickerButton: true,
        scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: hideEmptyScheduleWeek,
        ),
        scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,
        allowDragAndDrop: true,
        onLongPress: (CalendarLongPressDetails details) {
          dev.log('Drag and drop is allowed in week and day view only');
        },
        onDragEnd: (AppointmentDragEndDetails appointmentDragUpdateDetails) {
          dev.log(appointmentDragUpdateDetails.appointment.toString());
          // showAboutDialog(
          //   context: context,
          //   children: [Text('Drag and drop is allowed in week and day view')],
          // );
        },
        onViewChanged: viewChangedCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 4),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    _visibleDates = visibleDatesChangedDetails.visibleDates;
    if (_view == calendarController.view! ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _view = calendarController.view!;

        /// Update the current view when the calendar view changed to
        /// month view or from month view.
      });
    });
  }

  /// Navigates to appointment editor page when the calendar elements tapped
  /// other than the header, handled the editor fields based on tapped element.
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

    _selectedAppointment = null;

    /// Navigates the calendar to day view,
    /// when we tap on month cells in mobile.
    if (calendarController.view == CalendarView.month) {
      calendarController.view = CalendarView.day;
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.targetElement == CalendarElement.appointment) {
        final dynamic appointment = calendarTapDetails.appointments![0];
        if (appointment is Appointment) {
          _selectedAppointment = appointment;
        }
      }

      final DateTime selectedDate = calendarTapDetails.date!;
      final CalendarElement targetElement = calendarTapDetails.targetElement;

      /// Navigates to the appointment editor page on mobile
      Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => AppointmentEditor(
            _selectedAppointment,
            targetElement,
            selectedDate,
            _colorCollection,
            _colorNames,
            _events,
          ),
        ),
      );
    }
  }
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

bool isSameDate(d1, d2) {
  return d1.compareTo(d2) == 0;
}

/// Formats the tapped appointment time text, to display on the pop-up view.
String _getAppointmentTimeText(Appointment selectedAppointment) {
  if (selectedAppointment.isAllDay) {
    if (isSameDate(
        selectedAppointment.startTime, selectedAppointment.endTime)) {
      return DateFormat('EEEE, MMM dd').format(selectedAppointment.startTime);
    }
    return DateFormat('EEEE, MMM dd').format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('EEEE, MMM dd').format(selectedAppointment.endTime);
  } else if (selectedAppointment.startTime.day !=
          selectedAppointment.endTime.day ||
      selectedAppointment.startTime.month !=
          selectedAppointment.endTime.month ||
      selectedAppointment.startTime.year != selectedAppointment.endTime.year) {
    String endFormat = 'EEEE, ';
    if (selectedAppointment.startTime.month !=
        selectedAppointment.endTime.month) {
      endFormat += 'MMM';
    }

    endFormat += ' dd hh:mm a';
    return DateFormat('EEEE, MMM dd hh:mm a')
            .format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat(endFormat).format(selectedAppointment.endTime);
  } else {
    return DateFormat('EEEE, MMM dd hh:mm a')
            .format(selectedAppointment.startTime) +
        ' - ' +
        DateFormat('hh:mm a').format(selectedAppointment.endTime);
  }
}
