import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:openapp/pages/widgets/Form/service_form.dart';
import '../service_page.dart';
import 'hex_color.dart';

class TicketView extends StatelessWidget {
  final serviceName;
  final serviceDescription;
  final servicePrice;

  const TicketView(
      {Key? key,
      required this.serviceName,
      required this.serviceDescription,
      required this.servicePrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color ticketBackColor = HexColor('#F55353');
    Color ticketFrontColor = HexColor('#143F6B');
    Color textColor = Colors.white;
    return LimitedBox(
      maxHeight: 136,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Slidable(
          key: key,
          // The start action pane is the one at the left or the top side.
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            // dismissible: DismissiblePane(onDismissed: () {}),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 2,
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceForm(),
                    ),
                  );
                },
                backgroundColor: Colors.blue[200]!,
                foregroundColor: Colors.black,
                icon: Icons.archive,
                label: 'Edit',
              ),
            ],
          ),

          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  child: Container(
                    color: ticketBackColor,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipPath(
                            clipper: Ticketclipper(),
                            child: Container(
                              color: ticketFrontColor,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      serviceName,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ServiceForm(),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.all(0),
                                    ),
                                  ],
                                ),
                                Text(
                                  serviceDescription,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: ticketFrontColor,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                      width: 20,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        child: Flex(
                          children: List.generate(
                            10,
                            (index) => SizedBox(
                              height: 4,
                              width: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          direction: Axis.vertical,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: 20,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        servicePrice,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: HexColor('#FFEDD3'),
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.4),
                        //     blurRadius: 10,
                        //     offset: Offset(0, 5),
                        //   ),
                        // ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    color: ticketFrontColor,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey,
                    //     blurRadius: 5,
                    //     offset: Offset(7, 0),
                    //   ),
                    // ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ticketclipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.moveTo(size.width, size.height);
    path.lineTo(10, size.height);
    path.quadraticBezierTo(
      size.width / 1.2,
      size.height,
      size.width,
      0,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
