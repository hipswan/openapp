import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';

import '../../../utility/Network/network_connectivity.dart';
import '../../../utility/appurl.dart';
import '../../business_home.dart';
import 'dart:developer' as dev;

class InfoForm extends StatefulWidget {
  const InfoForm({Key? key}) : super(key: key);

  @override
  State<InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  var imagePath;
  final imgList = [
    currentBusiness?.image1 ?? '',
    currentBusiness?.image2 ?? '',
    currentBusiness?.image3 ?? '',
  ];
  var _currentImgIndex = 0;
  TextEditingController _description = TextEditingController();
  final List<Widget> imageSliders = [];
  @override
  void initState() {
    // TODO: implement initState
    imgList.where((item) => item.isNotEmpty).forEach(
      (item) {
        imageSliders.add(
          Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network('${AppConstant.PICTURE_ASSET_PATH}/$item',
                          fit: BoxFit.cover, width: 1000.0),
                      // Positioned(
                      //   bottom: 0.0,
                      //   left: 0.0,
                      //   right: 0.0,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Color.fromARGB(200, 0, 0, 0),
                      //           Color.fromARGB(0, 0, 0, 0)
                      //         ],
                      //         begin: Alignment.bottomCenter,
                      //         end: Alignment.topCenter,
                      //       ),
                      //     ),
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 10.0, horizontal: 20.0),
                      //     child: Text(
                      //       'No. ${imgList.indexOf(item)} image',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 20.0,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ),
          ),
        );
      },
    );

    super.initState();
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

  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
      preferredCameraDevice: CameraDevice.front,
    );
    if (file != null)
      setState(() {
        imagePath = file.path;
      });
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
      setState(() {
        imagePath = file.path;
      });
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select a file to upload'),
        ),
      );
    }
  }

  Future<String> uploadImage() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var headers = {'Authorization': 'Bearer ${currentBusiness?.token}'};

        var request = http.MultipartRequest(
            'POST', Uri.parse('$AppConstant.PICTURE_UPLOAD'));
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            '$imagePath',
          ),
        );
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var parsedBody = json.decode(await response.stream.bytesToString());
          return parsedBody['filename'];
        } else {
          throw Exception('Failed to upload image');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  Future maintainInfo() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = {
          "bId": currentBusiness?.bId,
          "description": _description.text,
          "image1": imgList.elementAt(0),
          "image2": imgList.elementAt(1) ?? "",
          "image3": imgList.elementAt(2) ?? "",
        };
        var response = await http.patch(
          Uri.parse('${AppConstant.getBusiness(currentBusiness?.bId)}'),
          body: body,
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business metadata');
        } else {
          throw Exception('Failed to update business metadeta');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Maintain Info'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  //TODO: loader start
                  if (imgList.length < 3) {
                    uploadImage().then((asset) async {
                      imgList.add(asset);
                      await maintainInfo();
                    }).catchError((e) => dev.log(e.toString()));
                  } else {
                    dev.log(
                      'Image add limit reached',
                    );
                  }
                  //TODO: Loader stop
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Form(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: secondaryColor.withOpacity(
                    0.8,
                  ),
                  child: Text(
                    'Saved to: ${currentBusiness?.bName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                // imageSliders.isNotEmpty?
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImgIndex = index;
                            // dev.log("${_currentImgIndex}");
                          });
                        },
                      ),
                      items: imageSliders,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.where((image) => image.isNotEmpty).map(
                        (image) {
                          //these two lines
                          int index = imgList.indexOf(image); //are changed
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImgIndex == index
                                    ? Color.fromRGBO(0, 0, 0, 0.9)
                                    : Color.fromRGBO(0, 0, 0, 0.4)),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
                imagePath != null
                    ? Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 240,
                              padding: EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: FileImage(
                                          File(imagePath),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: ElevatedButton(
                              onPressed: () {
                                selectImage(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade100,
                                ),
                                shape: MaterialStateProperty.all(
                                  CircleBorder(),
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(16),
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                selectImage(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade100,
                                ),
                                shape: MaterialStateProperty.all(
                                  CircleBorder(),
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(18),
                                ),
                              ),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Add a photo',
                                strutStyle: StrutStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    controller: _description,
                    decoration: InputDecoration(
                      labelText: 'Service Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
