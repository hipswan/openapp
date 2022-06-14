import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';

import '../pages/shop_page.dart';

class ShopTile extends StatelessWidget {
  final title;
  final location;
  final image;
  final rating;
  final price;
  final shopName;
  final category;
  const ShopTile({
    Key? key,
    this.title,
    this.location,
    this.image,
    this.rating,
    this.price,
    this.shopName,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopPage(
              shopName: shopName,
              category: category,
              image: image,
            ),
          ),
        );
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    SizedBox(
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
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 55,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text('\u2B50'),
                            Text(
                              '$rating',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      height: 30,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$title',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FittedBox(
              child: Text(
                shopName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              location,
              style: locationAndRatingTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
