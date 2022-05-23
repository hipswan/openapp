import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapp/pages/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

import '../model/user_controller.dart';

// CollectionReference sellerItemsRef =
//     FirebaseFirestore.instance.collection('sellerItems');
// firebase_storage.Reference? storageRef;

class PostItem extends StatefulWidget {
  // final User user = User(
  //     account: '0x059Ac2d11b1B59B1e66E23D885a8E3d6b3c5Ca63',
  //     name: 'atul',
  //     userType: 'seller');
  final filePath;
  PostItem({Key? key, required this.filePath}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>
    with AutomaticKeepAliveClientMixin<PostItem> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final itemName = TextEditingController();
  final itemPrice = TextEditingController();
  final itemDescription = TextEditingController();

  File? file;
  bool isUploading = false;
  String postId = Uuid().v4();

  // Container buildSplashScreen() {
  //   return Container(
  //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         SvgPicture.asset('assets/images/upload.svg', height: 260.0),
  //         Padding(
  //           padding: EdgeInsets.only(top: 20.0),
  //           child: RaisedButton(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //               ),
  //               child: Text(
  //                 "Upload Image",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 22.0,
  //                 ),
  //               ),
  //               color: Colors.deepOrange,
  //               onPressed: () => selectImage(context)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  // Future<String> uploadImage(imageFile) async {
  //   UploadTask uploadTask =
  //       storageRef!.child("post_$postId.jpg").putFile(imageFile);
  //   TaskSnapshot storageSnap = uploadTask.snapshot;
  //   String downloadUrl = await storageSnap.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    // String mediaUrl = await uploadImage(file);
    itemName.clear();
    itemPrice.clear();
    itemDescription.clear();
    setState(() {
      // file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
    Navigator.pop(context);
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearImage,
        ),
        centerTitle: true,
        title: Text(
          "Caption Post",
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              isUploading ? LinearProgressIndicator() : Text(""),
              Container(
                height: 220.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(file!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: itemName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: itemPrice,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Price per Item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        maxLines: 5,
                        maxLength: 150,
                        maxLengthEnforcement:
                            MaxLengthEnforcement.truncateAfterCompositionEnds,
                        controller: itemDescription,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Item Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: GestureDetector(
              onTap: isUploading ? null : () => handleSubmit(),
              child: Container(
                width: 70,
                height: 70,
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
                child: Center(
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String formattedAddress = "${position.latitude}, ${position.longitude}";
    locationController.text = formattedAddress;
  }

  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    file = File(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return buildUploadForm();
  }
}
