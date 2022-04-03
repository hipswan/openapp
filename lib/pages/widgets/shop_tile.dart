import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';

class ShopTile extends StatelessWidget {
  final title;
  final location;
  final image;
  final rating;
  final price;
  final shopName;

  const ShopTile(
      {Key? key,
      this.title,
      this.location,
      this.image,
      this.rating,
      this.price,
      this.shopName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/shop');
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 125,
                width: 150,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        image,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    location,
                    style: locationAndRatingTextStyle,
                  ),
                  const Spacer(),
                  const Text('\u2B50'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$rating',
                    style: locationAndRatingTextStyle,
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
