import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:openapp/pages/widgets/category_tile.dart';
import 'package:openapp/pages/widgets/section.dart';
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

final clinicDetails = [
  {
    'shopName': 'Minute',
    'title': 'Dr. Rajesh',
    'image': 'assets/images/minute.png',
    'location': 'Niagara',
    'rating': '4.5',
    'category': 'Clinic',
  },
  {
    'shopName': 'Entira',
    'title': 'Dr. John Doe',
    'image': 'assets/images/entira.png',
    'location': 'Niagara',
    'rating': '4.5',
    'category': 'Clinic',
  },
  {
    'shopName': 'Family',
    'title': 'Dr. John Doe',
    'image': 'assets/images/family.png',
    'location': 'Niagara',
    'rating': '4.5',
    'category': 'Clinic'
  },
];

final salonDetails = [
  {
    'shopName': 'Great Clips',
    'title': 'Jonny',
    'image': 'assets/images/greatclips.png',
    'location': 'Niagara',
    'rating': '4.5',
    'category': 'Salon',
  },
  {
    'shopName': 'Teez',
    'title': 'Fayla',
    'image': 'assets/images/teez.png',
    'location': 'Niagara',
    'rating': '4.5',
    'category': 'Salon',
  },
  {
    'shopName': 'Hairclub',
    'title': 'Micheal',
    'image': 'assets/images/hairclub.png',
    'location': 'Niagara',
    'rating': '4.5',
    'category': 'Salon'
  },
];

final categoryDetails = [
  {'name': 'Restaurant', 'image': 'assets/images/restaurant.png'},
  {'name': 'Salon', 'image': 'assets/images/salon.png'},
  {'name': 'Clinic', 'image': 'assets/images/clinic.png'},
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
    List<Widget> categoryList = categoryDetails
        .map(
          (e) => CategoryTile(
            image: e['image'],
            title: e['name'],
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

    List<Widget> clinicTiles = clinicDetails
        .map(
          (e) => ShopTile(
            image: e['image'],
            title: e['title'],
            location: e['location'],
            rating: e['rating'],
            price: e['price'],
            shopName: e['shopName'],
            category: e['category'],
          ),
        )
        .toList();

    Widget listClinicTile = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      height: 225,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: clinicTiles,
      ),
    );

    List<Widget> salonTiles = salonDetails
        .map(
          (e) => ShopTile(
            image: e['image'],
            title: e['title'],
            location: e['location'],
            rating: e['rating'],
            price: e['price'],
            shopName: e['shopName'],
            category: e['category'],
          ),
        )
        .toList();

    Widget listSalonTile = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      height: 225,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: salonTiles,
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
        'Reserve your spot at your favorite restaurant, salon or spa.',
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
            hintText: 'search for your favourite place?',
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
          'Welcome!',
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
            Section(
                sectionName: 'Top Trending Places',
                tagColor: Colors.green,
                tagName: 'New',
                onPressed: () {}),
            listShopTile,
            Section(sectionName: 'Explore Clinics', onPressed: () {}),
            listClinicTile,
            Section(sectionName: 'Explore Salon', onPressed: () {}),
            listSalonTile,
            exploreCategories,
            listCategoryTile,
          ],
        ),
      ),
    );
  }
}
