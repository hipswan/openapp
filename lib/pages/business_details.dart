import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:openapp/model/Service.dart';
import 'package:openapp/pages/widgets/staff.dart';
import 'package:openapp/pages/widgets/business_overview.dart';
import 'package:openapp/pages/widgets/services.dart';
import 'package:sliver_tools/sliver_tools.dart';

class BusinessDetail extends StatefulWidget {
  const BusinessDetail({Key? key}) : super(key: key);

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Business Details'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            TabBar(
              physics: NeverScrollableScrollPhysics(),
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 5.0,
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Services'),
                Tab(text: 'Staff'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BusinessOverview(),
                  // ProductPage(),
                  Services(),
                  Staffs(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class BusinessHeader extends StatelessWidget {
  const BusinessHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          child: Text('Business Details'),
        ),
      ],
    );
  }
}
