import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/widgets/Form/staff_form.dart';

import '../../model/staff.dart';

class StaffProfile extends StatefulWidget {
  final Staff staff;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const StaffProfile({
    Key? key,
    required this.staff,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  var isEditing = false;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;

    //Description
    Widget staffDescription = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: const [
          Text(
            'Description',
            style: homePageTextStyle,
          ),
        ],
      ),
    );

    //Description Text
    Widget shopDescriptionDetails(String description) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Text(
                '${widget.staff.desc}',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                ),
                strutStyle: StrutStyle(
                  fontSize: 16,
                  forceStrutHeight: true,
                ),
              ),
            ],
          ),
        );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Staff Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                label: Text(''),
                icon: Icon(
                  Icons.delete_forever_outlined,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  widget.onDelete();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                label: Text(''),
                icon: Icon(
                  Icons.edit_outlined,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  widget.onEdit();
                },
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffForm(),
              ),
            );
          },
          child: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: Colors.white,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 150,
                      width: maxWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/icons/calendar_circle.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(150),
                          bottomRight: Radius.circular(150),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                            blurStyle: BlurStyle.solid,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Hero(
                          tag: widget.key.hashCode,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              '${widget.staff.profilePicture}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
              ),
              decoration: BoxDecoration(
                color: thirdColor.withOpacity(
                  0.7,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ConnectTile(
                      asset: 'assets/images/connects/tiktok_logo.png',
                      label: '@${widget.staff.tiktokProfile}',
                    ),
                  ),
                  Expanded(
                    child: ConnectTile(
                      asset: 'assets/images/connects/fb_logo.png',
                      label: '@${widget.staff.fbProfile}',
                    ),
                  ),
                  Expanded(
                    child: ConnectTile(
                      asset: 'assets/images/connects/ig_logo.png',
                      label: '@${widget.staff.igProfile}',
                    ),
                  ),
                ],
              ),
            ),
            staffDescription,
            shopDescriptionDetails(widget.staff.desc!),
          ],
        ),
      ),
    );
  }
}

class ConnectTile extends StatelessWidget {
  final String asset;
  final String label;
  const ConnectTile({
    Key? key,
    required this.asset,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          width: 48,
          height: 48,
          image: AssetImage(
            asset,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
