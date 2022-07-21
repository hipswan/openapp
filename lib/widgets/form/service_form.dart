import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';

import '../../../model/service.dart';
import '../../../utility/Network/network_connectivity.dart';
import '../../../utility/appurl.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import '../../pages/business/business_home.dart';

class ServiceForm extends StatefulWidget {
  final Service? selectedService;
  final bool isEditable;
  const ServiceForm(
      {Key? key, required this.selectedService, required this.isEditable})
      : super(key: key);

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  var networkImgPath;
  var imagePath;
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _duration = TextEditingController();
  TextEditingController _description = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            'POST', Uri.parse('${AppConstant.PICTURE_UPLOAD}'));
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            '$imagePath',
          ),
        );
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201) {
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

  Future maintainService(asset) async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = {
          "bId": currentBusiness?.bId,
          "serviceName": _name.text,
          "cost": _price.text,
          "time": _duration.text,
          "desc": _description.text,
          "picture": asset,
        };
        var response;
        if (widget.selectedService == null && asset != null) {
          response = await http.post(
            Uri.parse('${AppConstant.BUSINESS_SERVICES})'),
            body: body,
            headers: {'Authorization': 'Bearer ${currentBusiness?.token}'},
          );
        } else {
          var url =
              AppConstant.updateBusinessService(widget.selectedService?.id);
          response = await http.patch(
            Uri.parse('$url'),
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
    _name.text = widget.selectedService?.name ?? "";
    _price.text = widget.selectedService?.price.toString() ?? "";
    _duration.text = widget.selectedService?.duration.toString() ?? "";
    _description.text = widget.selectedService?.description ?? "";
    networkImgPath = widget.selectedService?.images![0] ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    _updateStaffProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ServiceForm oldWidget) {
    // TODO: implement didUpdateWidget
    _updateStaffProperties();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: widget.isEditable
              ? Text('Maintain Services')
              : Text('${widget.selectedService?.name}'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              await Future.delayed(Duration(milliseconds: 100));
              Navigator.pop(context);
            },
          ),
          actions: [
            widget.isEditable
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(secondaryColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (_formKey.currentState!.validate() &&
                            imagePath != null) {
                          uploadImage().then((asset) async {
                            await maintainService(asset);
                            widget.selectedService?.images![0] = asset;
                            Navigator.pop(context);
                          }).catchError((e) => dev.log(e.toString()));
                        } else if (imagePath == null) {
                          await maintainService(networkImgPath);
                          widget.selectedService?.images![0] = networkImgPath;
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Text(''),
          ],
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: secondaryColor.withOpacity(
                    0.8,
                  ),
                  child: Text(
                    'Offered @: ${widget.selectedService?.location?.formattedAddress.toString() ?? ""}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                networkImgPath != null && networkImgPath.isNotEmpty
                    ? Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              20.0,
                            ),
                            height: 200,
                            child: networkImgPath.contains('svg')
                                ? SvgPicture.network('$networkImgPath')
                                : Image.network(
                                    '$networkImgPath',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          widget.isEditable
                              ? Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      selectImage(context);

                                      setState(() {
                                        networkImgPath = "";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                                )
                              : Container(),
                        ],
                      )
                    : imagePath != null
                        ? Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: 240,
                                  padding: EdgeInsets.all(20),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
                              widget.isEditable
                                  ? Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          selectImage(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
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
                                    )
                                  : Container(),
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
                //Service name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    enabled: widget.isEditable,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _price,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    enabled: widget.isEditable,
                    decoration: InputDecoration(
                      labelText: 'Service Price',
                      hintText: 'in \$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _duration,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter duration';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    enabled: widget.isEditable,
                    decoration: InputDecoration(
                      labelText: 'Service Duration',
                      hintText: 'in minutes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    controller: _description,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    enabled: widget.isEditable,
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
