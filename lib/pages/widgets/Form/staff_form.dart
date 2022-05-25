import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../model/staff.dart';
import '../../../utility/Network/network_connectivity.dart';
import '../../../utility/appurl.dart';
import '../../business_home.dart';
import 'dart:developer' as dev;

class StaffForm extends StatefulWidget {
  final Staff? selectedStaff;
  const StaffForm({
    Key? key,
    this.selectedStaff,
  }) : super(key: key);

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  var imagePath;
  TextEditingController _name = TextEditingController();
  TextEditingController _igHandle = TextEditingController();
  TextEditingController _fbHandle = TextEditingController();
  TextEditingController _tiktokHandle = TextEditingController();
  TextEditingController _description = TextEditingController();

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

  Future maintainStaff(asset) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = {
          "bId": currentBusiness?.bId,
          "firstName": _name.text,
          "igProfile": _igHandle.text,
          "fbProfile": _fbHandle.text,
          "tiktokProfile": _tiktokHandle.text,
          "desc": _description.text,
          "profilePicture": asset,
        };
        var response;
        if (widget.selectedStaff == null && asset != null) {
          response = await http.post(
            Uri.parse('$AppConstant.addBusinessStaff(${currentBusiness?.bId})'),
            body: body,
          );
        } else {
          response = await http.patch(
            Uri.parse('$AppConstant.addBusinessStaff(${currentBusiness?.bId})'),
            body: body,
          );
        }

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added staff');
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

  void _updateStaffProperties() {
    if (widget.selectedStaff != null) {
      _name.text = widget.selectedStaff?.firstName ?? '';
      _igHandle.text = widget.selectedStaff?.igProfile ?? '';
      _fbHandle.text = widget.selectedStaff?.fbProfile ?? '';
      _tiktokHandle.text = widget.selectedStaff?.tiktokProfile ?? '';
      imagePath = widget.selectedStaff?.profilePicture ?? '';
      _description.text = widget.selectedStaff?.desc ?? '';
    } else {
      _name.text = '';
      _igHandle.text = '';
      _fbHandle.text = '';
      _tiktokHandle.text = '';
      _description.text = '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _updateStaffProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StaffForm oldWidget) {
    // TODO: implement didUpdateWidget
    _updateStaffProperties();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Maintain Staff'),
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

                  uploadImage().then((asset) async {
                    await maintainStaff(asset);
                  }

                      //TODO: loader end

                      ).catchError((e) => dev.log(e));
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
                    'Saved to: ${currentBusiness?.bName ?? '/businessname'} ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
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
                                'Add a profile photo',
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
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                //TODO: handle validation
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConnectTile(
                    asset: 'assets/images/connects/ig_logo.png',
                    label: 'Instagram',
                    controller: _igHandle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConnectTile(
                    asset: 'assets/images/connects/tiktok_logo.png',
                    label: 'TikTok',
                    controller: _tiktokHandle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConnectTile(
                    asset: 'assets/images/connects/fb_logo.png',
                    label: 'Facebook',
                    controller: _fbHandle,
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

class ConnectTile extends StatelessWidget {
  final String asset;
  final String label;
  final TextEditingController controller;
  ConnectTile({
    Key? key,
    required this.asset,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          width: 48,
          height: 48,
          image: AssetImage(
            asset,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a $label handle';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
