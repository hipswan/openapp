import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'widgets/shop_offer_tile.dart';

class ShopPage extends StatelessWidget {
  final shopName;
  final category;
  final image;
  const ShopPage({Key? key, this.shopName, this.category, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    Widget shopPics = SizedBox(
      width: maxWidth - 40,
      height: 200,
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
          ),
        ),
      ),
    );
    Widget shopMetaData = Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shopName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$\$\$',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '3 Seats',
                  strutStyle: StrutStyle(
                    fontSize: 18,
                    forceStrutHeight: true,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Spacer(),
                Text(
                  'per person',
                  strutStyle: StrutStyle(
                    fontSize: 18,
                    forceStrutHeight: true,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ));
    //Shop Reviews
    Widget shopReviews = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\u2B50\u2B50\u2B50\u2B50\u2B50'),
              Text.rich(
                TextSpan(
                  text: '129 ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Reviews ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: '>',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // print('Reviews tapped');
                        },
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                strutStyle: const StrutStyle(
                  fontFamily: 'Serif',
                  fontSize: 18,
                  forceStrutHeight: true,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 140,
            height: 40,
            // color: Colors.black,
            child: Stack(
              children: List.generate(
                6,
                (index) => Positioned(
                  left: index * 20,
                  child: CircleAvatar(
                    radius: 20,
                    //white become more visible
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.accents[index],
                    child: Text('$index'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //Shop Offers
    Widget shopOffers = Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'What this place offers',
              style: homePageTextStyle,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'More',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            ),
          ],
        ));

    Widget shopOfferDetails = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        ShopOfferTile(
          icon: Icons.wifi,
          title: 'Wifi',
        ),
        ShopOfferTile(
          icon: Icons.pool,
          title: 'Pool',
        ),
        ShopOfferTile(
          icon: Icons.wash,
          title: 'Dryer',
        ),
      ],
    );

    //Description
    Widget shopDescription = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
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

    Widget shopDescriptionDetails = Column(
      children: const [
        Text(
          'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
    );

    //Main Shop Page
    Widget shopInfo = Positioned(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          shopPics,
          shopMetaData,
          shopReviews,
          shopOffers,
          shopOfferDetails,
          shopDescription,
          shopDescriptionDetails,
          SizedBox(
            height: maxHeight * 0.2 / 2,
          )
        ],
      ),
    );
    //book now or like button
    Widget bottomBox = Container(
      height: maxHeight * 0.15,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Colors.transparent,
        //     Colors.white.withOpacity(0.5),
        //     Colors.white,
        //   ],
        //   stops: const [
        //     0.3,
        //     0.3,
        //     0.5,
        //   ],
        // ),
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
        padding: const EdgeInsets.symmetric(
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
