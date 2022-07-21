import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:openapp/constant.dart';
import 'package:openapp/pages/login_page.dart';

import '../../../utility/Network/network_connectivity.dart';
import 'dart:developer' as dev;
import '../../model/category.dart';
import '../../model/service.dart';
import '../../model/shop.dart';
import '../../pages/business/business_home.dart';
import '../../utility/appurl.dart';

class BusinessForm extends StatefulWidget {
  final Shop? selectedBusiness;
  const BusinessForm({Key? key, this.selectedBusiness}) : super(key: key);

  @override
  State<BusinessForm> createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  var imagePath;
  List<String> imgList = [];
  var _currentImgIndex = 0;
  Shop? currentBusiness;
  TextEditingController _description = TextEditingController();
  TextEditingController _businessName = TextEditingController();
  TextEditingController _businessCity = TextEditingController();
  TextEditingController _businessState = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _streetAddress = TextEditingController();
  TextEditingController _businessLicense = TextEditingController();
  String? _businessCategory;
  List<DropdownMenuItem<String>>? _businessCategoryList;
  final List<Widget> imageSliders = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    _updateBusinessDetail();
    super.initState();
  }

  Future postBusinessForm() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        String url = AppConstant.POST_BUSINESS_DETAILS;
        var headers = {
          'x-auth-token': '${currentCustomer?.token}',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          'country': '',
          'state': _businessState.text,
          'city': _businessCity.text,
          'address': _streetAddress.text,
          'phone': _phoneNumber.text,
          'name': _businessName.text,
          'description': _description.text,
          'license': _businessLicense.text,
          'category': _businessCategory ?? "",
        });
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        var parsedJson;
        if (response.statusCode == 200) {
          dev.log(await response.stream.bytesToString());
          parsedJson = json.decode(await response.stream.bytesToString());
          return parsedJson["msg"];
        } else {
          parsedJson = json.decode(await response.stream.bytesToString());
          print(response.reasonPhrase);
          throw Exception('parsedJson["msg"]');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to internet');
    }
  }

  Future<Shop> getBusinessDetails() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        String url = AppConstant.CUSTOMER_BUSINESS;
        var request = http.Request(
          'GET',
          Uri.parse(url),
        );
        request.bodyFields = {};
        request.headers.addAll(<String, String>{
          'x-auth-token': '${currentCustomer?.token}',
        });
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var parsedJson = json.decode(await response.stream.bytesToString());
          return parsedJson.map<Shop>((json) => Shop.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch business services');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to internet');
    }
  }

  Future<List<Category>> getBusinessCategory() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        // var body = {
        //   "bId": currentBusiness?.bId.toString(),
        //   "lat": _position?.latitude.toString(),
        //   "long": _position?.longitude.toString(),
        // };

        var url = AppConstant.CATEGORY;
        var response = await http.get(
          Uri.parse('$url'),
        );

        if (response.statusCode == 200) {
          //  json.decode(response.body);
          dev.log('added/updated business category');
          var parsedJson = json.decode(response.body);
          return parsedJson
              .map<Category>((json) => Category.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to update business location');
        }
      } catch (e) {
        throw Exception('Failed to connect to server');
      }
    } else {
      throw Exception('Failed to connect to Intenet');
    }
  }

  _updateBusinessDetail() async {
    List<Category> category = await getBusinessCategory();
    _businessCategoryList = category
        .map<DropdownMenuItem<String>>((category) => DropdownMenuItem<String>(
              child: Text('${category.title ?? ""}'),
              value: category.title,
            ))
        .toList();
    if (widget.selectedBusiness?.id?.isNotEmpty ?? false) {
      try {
        // var currentBusiness = await getBusinessDetails();
        _businessName.text = widget.selectedBusiness?.name ?? "";
        _businessCity.text = widget.selectedBusiness?.city ?? "";
        _businessState.text = widget.selectedBusiness?.state ?? "";
        _phoneNumber.text = widget.selectedBusiness?.phone ?? "";
        _streetAddress.text =
            widget.selectedBusiness?.location?.formattedAddress ?? "";
        _businessLicense.text = widget.selectedBusiness?.license ?? "";
        _businessCategory = widget.selectedBusiness?.category ?? "";
        _description.text = widget.selectedBusiness?.description ?? '';

        setState(() {
          imgList = widget.selectedBusiness?.images ?? [];
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
                            Image.network('$item',
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

          _isLoading = false;
        });
      } catch (e) {
        dev.log(e.toString());
        setState(() {
          _businessName.text = "";
          _businessCity.text = "";
          _businessState.text = "";
          _phoneNumber.text = "";
          _streetAddress.text = "";
          _businessLicense.text = "";
          _businessCategory = "";
          _description.text = "";
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _businessName.text = "";
        _businessCity.text = "";
        _businessState.text = "";
        _phoneNumber.text = "";
        _streetAddress.text = "";
        _businessLicense.text = "";
        _businessCategory = "";
        _description.text = "";
        _isLoading = false;
      });
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
        var headers = {'x-auth-token': '${currentCustomer?.token}'};

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

  Future maintainInfo() async {
    if (await CheckConnectivity.checkInternet()) {
      try {
        var body = {
          "bId": currentCustomer?.id.toString(),
          "description": _description.text,
          "image1": imgList.elementAt(0),
          "image2": imgList.elementAt(1),
          "image3": imgList.elementAt(2),
        };
        var response = await http.patch(
          Uri.parse('${AppConstant.getBusiness(currentCustomer?.id)}'),
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              await Future.delayed(
                Duration(
                  milliseconds: 200,
                ),
              );
              Navigator.pop(context);
            },
          ),
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

                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await postBusinessForm();

                      setState(() {
                        _isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'One of our admins will approve the business if the details are valid. This process might take up to 24 hrs.'),
                              actions: [
                                ElevatedButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )),
                      );
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  '${e.toString()}\n Facing issue with this slot, please try again later'),
                              actions: [
                                ElevatedButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )),
                      );
                    }
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
                    'Saved to: ${currentCustomer?.firstname} ${currentCustomer?.lastname}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                // imageSliders.isNotEmpty?
                imageSliders.isNotEmpty
                    ? Column(
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
                            children:
                                imgList.where((image) => image.isNotEmpty).map(
                              (image) {
                                //these two lines
                                int index =
                                    imgList.indexOf(image); //are changed
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
                      )
                    : Container(),
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
                //business name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _businessName,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //description
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
                    decoration: InputDecoration(
                      labelText: 'Service Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //phone number
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneNumber,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //street address
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _streetAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your street address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Street Address',
                      hintText: '123 Main St',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //business type
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: _businessCategory,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter business type';
                      }
                      return null;
                    },
                    items: _businessCategoryList ?? [],
                    onChanged: (value) {
                      setState(() {
                        _businessCategory = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //business State
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _businessState,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter state';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'State',
                      hintText: 'Enter State',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //Business City
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _businessCity,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'City',
                      hintText: 'Enter City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //Business License
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _businessLicense,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your business license';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Business License',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
