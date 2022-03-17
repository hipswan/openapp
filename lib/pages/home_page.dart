import 'package:flutter/material.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/widgets/category_tile.dart';
import 'package:openapp/pages/widgets/shop_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget topSection = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Top Trending Places',
          style: homePageTextStyle,
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
      ],
    );
    List<Widget> shopTiles = List.generate(
      10,
      (e) => const ShopTile(
        image: 'assets/images/shop1.jpg',
        title: 'Hotel light sky',
        location: 'Niagara, Buffalo',
        rating: 4.5,
        price: '\$100',
      ),
    );

    List<Widget> categoryList = List.generate(
      10,
      (e) => CategoryTile(
        image: 'assets/images/category1.jpg',
        title: 'Category $e',
      ),
    );

    Widget listCategoryTile = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      height: 225,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categoryList,
      ),
    );

    Widget listShopTile = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      height: 225,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: shopTiles,
      ),
    );

    Widget exploreCategories = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          const Text(
            'Explore Categories',
            style: homePageTextStyle,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
          ),
          IconButton(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
        ],
      ),
    );

    Widget introText = const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Text(
        'Reserve spot at your favorite restaurants, barber shop or spa.',
        strutStyle: StrutStyle(
          forceStrutHeight: true,
          height: 2.2,
        ),

        maxLines: 2,
        // strutStyle: StrutStyle(
        //   height: 2,
        // ),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: Colors.black,
          letterSpacing: 1,
        ),
      ),
    );

    Widget searchWidget = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 246, 247, 247),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const TextField(
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'where do you want to go?',
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Welcome, Flutter!',
          style: homePageTextStyle,
        ),
        centerTitle: true,
        shadowColor: Color.fromARGB(128, 32, 147, 255),
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: FlutterLogo(),
              radius: 20,
            ),
          ),
        ],
      ),
      body: Container(
        color: homePageColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
        child: ListView(
          children: [
            introText,
            searchWidget,
            topSection,
            listShopTile,
            exploreCategories,
            listCategoryTile,
          ],
        ),
      ),
    );
  }
}
