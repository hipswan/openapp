import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/widgets/category_tile.dart';
import 'package:openapp/pages/widgets/shop_tile.dart';

final shopDetails = [
  {
    'shopName': 'Golden Duck',
    'item': 'Butter Chicken',
    'image': 'assets/images/chicken.jpeg',
    'location': 'Niagara',
    'rating': '4.5',
    'price': 100,
    'category': 'Indian',
  },
  {
    'shopName': 'Blacebo',
    'item': 'Beans',
    'image': 'assets/images/beans.jpeg',
    'location': 'Niagara',
    'rating': '4.5',
    'price': 100,
    'category': 'Indian'
  },
  {
    'shopName': 'Basta',
    'item': 'Noodles',
    'image': 'assets/images/noodles.jpeg',
    'location': 'Niagara',
    'rating': '4.5',
    'price': 100,
    'category': 'Italian'
  },
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
      preferredCameraDevice: CameraDevice.front,
    );
    if (file != null)
      await Navigator.pushNamed(context, '/post', arguments: file.path);
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select a file to upload'),
        ),
      );
    }
    // setState(() {
    //   this.file = File(file!.path);
    // });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (file != null)
      Navigator.pushNamed(context, '/post', arguments: file.path);
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select a file to upload'),
        ),
      );
    }
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget topSection = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Text(
          'Top Trending Places',
          style: homePageTextStyle,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.green,
          ),
          child: const Text(
            'New',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
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
    List<Widget> shopTiles = shopDetails
        .map(
          (e) => ShopTile(
            image: e['image'],
            title: e['item'],
            location: e['location'],
            rating: e['rating'],
            price: e['price'],
            shopName: e['shopName'],
          ),
        )
        .toList();

    List<Widget> categoryList = shopDetails
        .map(
          (e) => CategoryTile(
            image: e['image'],
            title: e['category'],
          ),
        )
        .toList();

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
        'Book your delicious meal from your favourite Restaurants.',
        strutStyle: StrutStyle(
          forceStrutHeight: true,
          fontSize: 26,
        ),

        // strutStyle: StrutStyle(
        //   height: 2,
        // ),
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Montserrat',
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
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.search),
            hintText: 'What cuisine do you like?',
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectImage(context);
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Welcome, ${currentUser!.name}!',
          style: homePageTextStyle,
        ),
        centerTitle: true,
        shadowColor: const Color.fromARGB(128, 32, 147, 255),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
