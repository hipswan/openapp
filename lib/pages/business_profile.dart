import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/widgets/Form/info_form.dart';
import 'package:openapp/pages/widgets/business_location.dart';
import 'package:openapp/pages/widgets/hex_color.dart';
import 'package:openapp/pages/widgets/info_wall.dart';
import 'package:openapp/pages/widgets/services.dart';
import 'package:openapp/pages/widgets/staff.dart';

import '../utility/appurl.dart';
import 'business_home.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  @override
  Widget build(BuildContext context) {
    Widget businessMetaData = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              margin: EdgeInsets.all(10),
              child: currentBusiness?.image1 != null
                  ? CachedNetworkImage(
                      imageUrl:
                          '${AppConstant.PICTURE_ASSET_PATH}/${currentBusiness?.image1}',
                      placeholder: (context, value) =>
                          CircularProgressIndicator(),
                      fit: BoxFit.cover,
                    )
                  : FlutterLogo(),
            ),
            Positioned(
              right: 0,
              top: 0,
              width: 20,
              height: 20,
              child: Image(
                image: AssetImage(
                  'assets/images/verified.png',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentBusiness?.bName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${currentBusiness?.description}',
            ),
            SizedBox(
              height: 25,
            ),
            Card(
              color: secondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booked',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '# of bookings',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: SizedBox(
            height: 40.0,
            width: 40.0,
            child: FloatingActionButton(
              heroTag: 'Edit_User_Profile',
              backgroundColor: Colors.redAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (InfoForm()),
                  ),
                );
              },
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Profile'),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: DefaultTabController(
          length: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: businessMetaData,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Material(
                  color: HexColor('#F5F5F5'),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  child: TabBar(
                    isScrollable: true,
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
                      Tab(
                        text: 'Info',
                      ),
                      Tab(
                        text: 'Services',
                      ),
                      Tab(
                        text: 'Staff',
                      ),
                      Tab(
                        text: 'Location',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    InfoWall(),
                    Services(),
                    Staffs(),
                    BusinessLocation(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
