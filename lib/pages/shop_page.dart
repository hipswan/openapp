import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    Widget shopPics = SizedBox(
      width: maxWidth - 40,
      height: 200,
      child: const Placeholder(
        color: Colors.grey,
      ),
    );
    Widget shopMetaData = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Hotel light sky',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$100',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: const [
            Text(
              '3 Seats',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              '1 bathroom',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              'Complimentary Spa',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Text(
              'per person',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );

    Widget shopInfo = Positioned(
      child: Column(
        children: [
          shopPics,
          shopMetaData,
        ],
      ),
    );
    //book now or like button
    Widget bottomBox = Container(
      height: maxHeight * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white,
          ],
          stops: const [
            0.2,
            0.3,
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          children: [
            //like button
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(
                10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_outline_rounded,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),

            Expanded(
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(
                  10.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(
                            0.3,
                          ),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: maxWidth,
        height: maxHeight,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Stack(
          children: [
            shopInfo,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: bottomBox,
            )
          ],
        ),
      ),
    );
  }
}
