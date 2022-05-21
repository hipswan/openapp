import 'package:flutter/material.dart';
import 'package:openapp/pages/widgets/ticket_view.dart';

import 'Form/service_form.dart';
import 'hex_color.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  var _services = [
    {
      'name': 'Service 1',
      'description': 'Description of Service 1',
      'price': '\$10',
      'image': 'assets/images/service1.png',
    },
    {
      'name': 'Service 2',
      'description': 'Description of Service 2',
      'price': '\$20',
      'image': 'assets/images/service2.png',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceForm(),
              ));
        },
        backgroundColor: HexColor('#143F6B'),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Info',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Select a service to view its details'),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  ..._services.map<Widget>(
                    (service) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: TicketView(
                        key: Key(service['name']!),
                        serviceName: service['name'],
                        serviceDescription: service['description'],
                        servicePrice: service['price'],

                        // image: 'assets/images/service1.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
