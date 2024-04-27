import 'dart:async';
import 'dart:convert';
import 'package:kisaan_electric/home/view/home_view.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/image_pickerController.dart';
import 'package:kisaan_electric/profile/controller/profileController.dart';
import 'package:kisaan_electric/wallet/controller/wallte_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class profile_view extends StatefulWidget {
  const profile_view({super.key});

  @override
  State<profile_view> createState() => _profile_viewState();
}

class _profile_viewState extends State<profile_view> {
  imagePickercontroller imagecontroller = Get.put(imagePickercontroller());
  wallet_controller controller = Get.put(wallet_controller());
  profilecontroller profileController = Get.put(profilecontroller());
  RxString groupValue = '1'.obs;
  RxString profilegroupvalue = '1'.obs;
  String personalDate = '';
  String AdditionalDate1 = '';
  String AdditionalDate2 = '';
  String AdditionalDate3 = '';
  String radiou = '';
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  bool isLoading4 = false;
  bool isLoading5 = false;
  bool isLoading6 = false;
  bool showSpinner = false;
  bool edit = false;
  bool update = false;
  bool check = false;
  bool transferEdit = false;
  bool documentEdit = false;
  bool additionEdit = false;
  var marriedstaus;
  var nationality;
  var bloodgroup;
  // Image Picker

  // Text Controller
  TextEditingController fullName = TextEditingController();
  TextEditingController bussinessName = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController whatsapno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accounNo = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController accontHolderName = TextEditingController();
  TextEditingController paythmNo = TextEditingController();
  TextEditingController googlePayNo = TextEditingController();
  TextEditingController phonePayNo = TextEditingController();
  TextEditingController aadharno = TextEditingController();
  TextEditingController panNumber = TextEditingController();
  TextEditingController GstNumber = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController studyfirst = TextEditingController();
  TextEditingController firstdob = TextEditingController();
  TextEditingController secondname = TextEditingController();
  TextEditingController seconddob = TextEditingController();
  TextEditingController secondstudyin = TextEditingController();
  TextEditingController thrdname = TextEditingController();
  TextEditingController thrddob = TextEditingController();
  TextEditingController thrdstudy = TextEditingController();
  TextEditingController reading = TextEditingController();
  TextEditingController anniversy = TextEditingController();
  TextEditingController writings = TextEditingController();
  TextEditingController speaking = TextEditingController();
  TextEditingController cin = TextEditingController();
  TextEditingController workExperience = TextEditingController();
  var gender;
  File? SelectedImage;
  File? SelectedImage1;
  File? SelectedImage2;
  File? SelectedImage3;
  File? SelectedImage4;
  File? SelectedImage5;
  File? SelectedImage6;
  File? SelectedImage7;
  File? Compressh1;
  File? Compressh2;
  File? Compressh3;
  File? profileImagecir;
  int percentage = 0;
  var Nationalityd;
  var profileimageback;
  var cancelCheckBack;
  var pasbookBack;
  var KycBack;

  String _radioVal = "";
  int? _radioSelected;
  String radioVall = "";
  int? radioSelectedd;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  String outputPath = '/path/to/compressed/image.jpg';
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Profilebasics();
    getConnectivity();
  }

  Future profileImage() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/profile.jpg';

    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);

    setState(() {
      profileImagecir = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future profileimageCamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/profile.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);
    setState(() {
      profileImagecir = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future imagePicker() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);
    setState(() async {
      SelectedImage = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future imagePickerCamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);

    setState(() {
      SelectedImage = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future imagePicker1() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp1.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);
    setState(() {
      SelectedImage1 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future imagePickerCamera1() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp1.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);
    setState(() {
      SelectedImage1 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future imagePicker2() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp2.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);
    setState(() {
      SelectedImage2 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future imagePickerCamera2() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp2.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);

    setState(() {
      SelectedImage2 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future aadharFront() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp3.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage3 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future aadharFrontcamer() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp3.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage3 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future aadharback() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp4.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage4 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future aadharbackCamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp4.jpg';

    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage4 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future pancard() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp5.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage5 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future pancardcamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp5.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage5 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future gstupload() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp6.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage6 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future gstcamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp6.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage6 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future shopImage() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp7.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);

    setState(() {
      SelectedImage7 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  Future shopcamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp7.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 20);
    setState(() {
      SelectedImage7 = File(result!.path);
      Navigator.of(context).pop();
    });
  }

  bool isvalidEmail = true;
  var value = null;
  void validate(context) {
    if (email.text.isEmpty) {
      isvalidEmail = true;
      const snackBar = SnackBar(
        content: Text('Email is Empty!'),
      );
// ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email.text)) {
      isvalidEmail = false;
      const snackBar = SnackBar(
        content: Text('Not a valid Email!'),
        // behavior: SnackBarBehavior.floating,
        //backgroundColor: Colors.amber,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      isvalidEmail = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white),
        child: WillPopScope(
          onWillPop: () async {
            Get.offAll(Home_view());
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                customAppBar(AppLocalizations.of(context)!.myProfile, '1'),
                Container(
                  height: 1,
                  width: Get.width,
                  color: appcolor.borderColor,
                ),
                FutureBuilder(
                  future: Profilebasic(''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      var date = data['created_at'];
                      var split = date.split('T');
                      var split1 = split[0];
                      var datechange = split1.split('-');

                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (edit == true) {
                                      showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 80,
                                              color: appcolor.redColor,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            profileimageCamera();
                                                          },
                                                          icon: Icon(
                                                            Icons.camera,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Camera',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            profileImage();
                                                          },
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .file,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'File',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  },
                                  child: Container(
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: appcolor.borderColor,
                                          radius: 40,
                                          child: CircleAvatar(
                                            backgroundColor: appcolor.greyColor,
                                            radius: 39,
                                            child: ClipOval(
                                              child: profileImagecir == null
                                                  ? data['profile_pic'] == ''
                                                      ? Image.asset(
                                                          'assets/Vector.png')
                                                      : Image.network(
                                                          '${apiDomain().imageUrl + data['profile_pic']}',
                                                          fit: BoxFit.cover,
                                                          width: 100,
                                                          height: 100,
                                                        )
                                                  : Image.file(
                                                      profileImagecir!,
                                                      fit: BoxFit.cover,
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: Get.height * 0.09),
                                          height: Get.height * 0.03,
                                          width: Get.width * 0.24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: appcolor.borderColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: percentage <= 10
                                                ? appcolor.redColor
                                                : percentage <= 60
                                                    ? Color(0xffECFF0C)
                                                    : Colors.green,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$percentage%',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        '${AppLocalizations.of(context)!.name} : ${data['name']}',
                                        style: TextStyle(
                                          height: 1.5,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        '${AppLocalizations.of(context)!.phone} : +91 ${data['mobile_no']}',
                                        style: TextStyle(
                                          height: 0.6,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.registeredOn}: ${datechange[2]}-${datechange[1]}-${datechange[0]}',
                                      style: TextStyle(
                                        height: 1.2,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(left: 5),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Image.asset(apiDomain().nodataimage.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(),
                  height: Get.height * 0.04,
                  child: TabBar(
                    dividerColor: appcolor.newRedColor,
                    isScrollable: true,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                    ),
                    indicatorColor: appcolor.redColor,
                    // indicator: ,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(gradient: appcolor.gradient),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    padding: EdgeInsets.zero,
                    //labelPadding: EdgeInsets.zero,
                    controller: controller.tabcontroller,
                    tabs: [
                      Container(
                        height: 70,
                        width: 120,
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.personalInfo,
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 120,
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.transferInfo,
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 120,
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.documentInfo,
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 120,
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.additionalInfo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabcontroller,
                    children: [
                      personelInfo(),
                      TransferInfo(),
                      Documents(),
                      AdditionalInfo(),
                    ],
                  ),
                )
              ],
            ),
            floatingActionButton: floatingActionButon(context),
          ),
        ),
      ),
    );
  }

  Future<void> profilePhotoUpdate(String Name, Email, Mobileno, WhatsaapNo,
      Address, PinCode, Country, states, City, Radial, DOB, gender, bus) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var choose = profilegroupvalue.value.toString();
      var uri = Uri.parse(
          '${apiDomain().domain}profileinfo'); // Replace with your server's endpoint

      var request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = '$Name'
        ..fields['email'] = '$Email'
        ..fields['mobile_no'] = '$Mobileno'
        ..fields['whatsapp_number'] = '$WhatsaapNo'
        ..fields['address'] = '$Address'
        ..fields['pincode'] = '$PinCode'
        ..fields['country'] = '$Country'
        ..fields['state'] = '$states'
        ..fields['city'] = '$City'
        ..fields['profile_pic'] = '$profileimageback'
        ..fields['gender'] = '${Radial == '' ? gender : Radial}'
        ..fields['business_name'] = '$bus'
        ..fields['dob'] = '$DOB';

      // Add images to the request
      if (profileImagecir != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_pic',
            profileImagecir == null
                ? profileimageback
                : profileImagecir!.path));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        if (rest['status'] == true) {
          setState(() {
            edit = false;
            isLoading1 = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${rest['message']}')));
        } else {
          alertBoxdialogBox(context, 'Alert', '${rest['message']}');
        }
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      } else {
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //Personal infomation get data
  Future Profilebasic(Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response =
        await http.post(Uri.parse('${apiDomain().domain}profileinfo'),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dataa = data['data'];
      percentage = data['percentage'];
      dataa[0]['country'] == null ? '' : country.text = dataa[0]['country'];
      dataa[0]['state'] == null ? '' : state.text = dataa[0]['state'];
      dataa[0]['name'] == null ? '' : fullName.text = dataa[0]['name'];
      dataa[0]['business_name'] == null
          ? ''
          : bussinessName.text = dataa[0]['business_name'];
      dataa[0]['dob'] == null ? '' : dateofbirth.text = dataa[0]['dob'];
      dataa[0]['mobile_no'] == null ? '' : mobile.text = dataa[0]['mobile_no'];
      dataa[0]['email'] == null ? '' : email.text = dataa[0]['email'];
      dataa[0]['address'] == null ? '' : address.text = dataa[0]['address'];
      dataa[0]['pincode'] == null
          ? ''
          : pincode.text = dataa[0]['pincode'].toString();
      dataa[0]['city'] == null ? '' : city.text = dataa[0]['city'];
      dataa[0]['whatsapp_number'] == null
          ? ''
          : whatsapno.text = dataa[0]['whatsapp_number'].toString();
      dataa[0]['bank_name'] == null
          ? ''
          : bankName.text = dataa[0]['bank_name'].toString();
      dataa[0]['Ac_number'] == null
          ? ''
          : accounNo.text = dataa[0]['Ac_number'].toString();
      dataa[0]['ifsc_code'] == null
          ? ''
          : ifscCode.text = dataa[0]['ifsc_code'];
      dataa[0]['holder_name'] == null
          ? ''
          : accontHolderName.text = dataa[0]['holder_name'];
      dataa[0]['paytm_no'] == null
          ? ''
          : paythmNo.text = dataa[0]['paytm_no'].toString();
      dataa[0]['googlepay_no'] == null
          ? ''
          : googlePayNo.text = dataa[0]['googlepay_no'].toString();
      dataa[0]['phonepay_no'] == null
          ? ''
          : phonePayNo.text = dataa[0]['phonepay_no'].toString();
      dataa[0]['aadhar_no'] == null
          ? ''
          : aadharno.text = dataa[0]['aadhar_no'].toString();
      dataa[0]['pan_no'] == null ? '' : panNumber.text = dataa[0]['pan_no'];
      dataa[0]['gst_no'] == null ? '' : GstNumber.text = dataa[0]['gst_no'];
      dataa[0]['oneChildName'] == null
          ? ''
          : firstname.text = dataa[0]['oneChildName'];
      dataa[0]['oneChildDate'] == null
          ? ''
          : firstdob.text = dataa[0]['oneChildDate'];
      dataa[0]['oneChildStudy'] == null
          ? ''
          : studyfirst.text = dataa[0]['oneChildStudy'];
      dataa[0]['secondChildName'] == null
          ? ''
          : secondname.text = dataa[0]['secondChildName'];
      dataa[0]['secondChildDate'] == null
          ? ''
          : seconddob.text = dataa[0]['secondChildDate'];
      dataa[0]['anniversary'] == "0000-00-00"
          ? ''
          : anniversy.text = dataa[0]['anniversary'].toString();
      dataa[0]['secondChildStudy'] == null
          ? ''
          : secondstudyin.text = dataa[0]['anniversary'];
      dataa[0]['thirdChildName'] == null
          ? ''
          : thrdname.text = dataa[0]['thirdChildName'];
      dataa[0]['thirdChildDate'] == null
          ? ''
          : thrddob.text = dataa[0]['thirdChildDate'];
      dataa[0]['thirdChildStudy'] == null
          ? ''
          : thrdstudy.text = dataa[0]['thirdChildStudy'];
      dataa[0]['reading'] == null ? '' : reading.text = dataa[0]['reading'];
      dataa[0]['writing'] == null ? '' : writings.text = dataa[0]['writing'];
      dataa[0]['speaking'] == null ? '' : speaking.text = dataa[0]['speaking'];
      dataa[0]['partner'] == null ? '' : cin.text = dataa[0]['partner'];
      dataa[0]['experiance'] == null
          ? ''
          : workExperience.text = dataa[0]['experiance'].toString();
      //  _radioSelected = dataa[0]['gender']== 'male'?1:2;
      nationality =
          dataa[0]['nationality'] == null ? 'india' : dataa[0]['nationality'];
      marriedstaus = dataa[0]['marital_status'] == null
          ? null
          : dataa[0]['marital_status'] == 'unmarried'
              ? 'Unmarried'
              : "Married";
      bloodgroup = dataa[0]['bloodgroup'];
      profileimageback = dataa[0]['profile_pic'];
      cancelCheckBack = dataa[0]['cancelled_cheque'];
      pasbookBack = dataa[0]['passbook'];
      KycBack = dataa[0]['paytm_kyc'];

      return dataa[0];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  Future Profilebasics() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response =
        await http.post(Uri.parse('${apiDomain().domain}profileinfo'),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dataa = data['data'];
      setState(() {
        _radioSelected = dataa[0]['gender'] == 'male'
            ? 1
            : dataa[0]['gender'] == 'female'
                ? 2
                : null;
        radioSelectedd = int.parse(dataa[0]['children_info'] == null
            ? '1'
            : dataa[0]['children_info']);
        groupValue.value =
            dataa[0]['marital_status'] == 'unmarried' ? '2' : '1';
      });
      // print(dataa);
      return dataa[0];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

// update data personal infromation
  Future ProfileUpdate(String url, Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print('sdafsa$value');
    setState(() {
      showSpinner = true;
    });
    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          Future.delayed(Duration(seconds: 2), () {
            showSpinner = false;
          });
          edit = false;
          update = false;
          check = false;
          transferEdit = false;
          documentEdit = false;
          additionEdit = false;
          isLoading1 = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data['message']}')));
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
        setState(() {
          showSpinner = false;
        });
      }
      return data[0];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  // Pincode get data
  Future PinCodeGenerate(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('https://api.postalpincode.in/pincode/$code'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var dataa = data[0]['PostOffice'];
      country.text = dataa[0]['Country'].toString();
      state.text = dataa[0]['State'].toString();
      city.text = dataa[0]['Block'].toString();
      // print(dataa);
      return dataa;
    }
  }

  Widget personelInfo() {
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: FutureBuilder(
            future: api().GetData('transferinfo', ''),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Image.asset(apiDomain().nodataimage),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      bool check = false;
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              data['profession'] == 'electrician'
                                  ? Container()
                                  : Container(
                                      height: Get.height * 0.055,
                                      child: customtextformfield(
                                          controller: bussinessName,
                                          enabled: edit,
                                          readOnly: true,
                                          verticalContentPadding: 0,
                                          hinttext: 'Bussiness Name',
                                          hintTextColor: Colors.black,
                                          bottomLineColor: Color(0xffb8b8b8),
                                          suffixIcon: Container(
                                              height: Get.height * 0.00009,
                                              child: Icon(
                                                Icons.business,
                                                color: appcolor.redColor,
                                              )),
                                          newIcon: Container(
                                              height: Get.height * 0.00009,
                                              child: Icon(
                                                Icons.business,
                                                color: appcolor.redColor,
                                              ))),
                                    ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                    controller: fullName,
                                    enabled: edit,
                                    readOnly: true,
                                    verticalContentPadding: 0,
                                    hinttext:
                                        AppLocalizations.of(context)!.fullName,
                                    hintTextColor: Colors.black,
                                    bottomLineColor: Color(0xffb8b8b8),
                                    suffixIcon: Container(
                                        height: Get.height * 0.00009,
                                        child: Icon(
                                          Icons.person,
                                          color: appcolor.redColor,
                                        )),
                                    newIcon: Container(
                                        height: Get.height * 0.00009,
                                        child: Icon(
                                          Icons.person,
                                          color: appcolor.redColor,
                                        ))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: _radioSelected,
                                        activeColor: Colors.red,
                                        onChanged: (value) {
                                          if (edit == true) {
                                            setState(() {
                                              _radioSelected =
                                                  int.parse(value.toString());
                                              _radioVal = 'male';
                                              //  print(_radioVal);
                                            });
                                          }
                                        },
                                      ),
                                      Text(AppLocalizations.of(context)!.male),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 2,
                                        groupValue: _radioSelected,
                                        activeColor: Colors.red,
                                        onChanged: (value) {
                                          if (edit == true) {
                                            setState(() {
                                              _radioSelected =
                                                  int.parse(value.toString());
                                              _radioVal = 'female';
                                              print(_radioVal);
                                            });
                                          }
                                        },
                                      ),
                                      Text(
                                          AppLocalizations.of(context)!.female),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: Get.height * 0.055,
                                // width: Get.width * 0.45,
                                child: customtextformfield(
                                  enabled: edit,
                                  controller: dateofbirth,
                                  readOnly: true,
                                  callback: () async {
                                    if (edit == true) {
                                      dateofbirth.text = await profileController
                                          .showdatepicker(context);
                                    }
                                  },
                                  key_type: TextInputType.datetime,
                                  hinttext:
                                      AppLocalizations.of(context)!.birthDate,
                                  hintTextColor: Colors.black,
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Image.asset(
                                        'assets/birthdate.png',
                                        color: appcolor.redColor,
                                      )),
                                  bottomLineColor: Color(0xffb8b8b8),
                                ),
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                  readOnly: true,
                                  enabled: edit,
                                  controller: mobile,
                                  key_type: TextInputType.phone,
                                  verticalContentPadding: 0,
                                  hinttext:
                                      AppLocalizations.of(context)!.phoneNumber,
                                  maxLength: 10,
                                  hintTextColor: Colors.black,
                                  bottomLineColor: Color(0xffb8b8b8),
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Image.asset(
                                        'assets/support.png',
                                        color: appcolor.redColor,
                                      )),
                                ),
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                  // readOnly: edit == true ? false:true,
                                  enabled: edit,
                                  controller: whatsapno,
                                  key_type: TextInputType.phone,
                                  verticalContentPadding: 0,
                                  hinttext:
                                      AppLocalizations.of(context)!.whatsapp,
                                  hintTextColor: Colors.black,
                                  bottomLineColor: Color(0xffb8b8b8),
                                  maxLength: 10,
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Image.asset(
                                        'assets/whatsapp.png',
                                        color: appcolor.redColor,
                                      )),
                                ),
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: customtextformfield(
                                    //  readOnly: edit == true ? false:true,
                                    enabled: edit,
                                    controller: email,
                                    verticalContentPadding: 0,
                                    hinttext:
                                        AppLocalizations.of(context)!.email,
                                    key_type: TextInputType.emailAddress,
                                    hintTextColor: Colors.black,
                                    bottomLineColor: Color(0xffb8b8b8),
                                    newIcon: Container(
                                        height: Get.height * 0.025,
                                        child: Image.asset(
                                          'assets/email.png',
                                          color: appcolor.redColor,
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                  // readOnly: edit == true ? false:true,
                                  enabled: edit,
                                  controller: address,
                                  verticalContentPadding: 0,
                                  hinttext:
                                      AppLocalizations.of(context)!.address,
                                  key_type: TextInputType.streetAddress,
                                  hintTextColor: Colors.black,
                                  bottomLineColor: Color(0xffb8b8b8),
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Image.asset(
                                        'assets/location.png',
                                        color: appcolor.redColor,
                                      )),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: Get.width * 0.5,
                                    height: Get.height * 0.055,
                                    child: customtextformfield(
                                      // readOnly: edit == true ? false:true,
                                      enabled: edit,
                                      controller: pincode,
                                      verticalContentPadding: 0,
                                      hinttext:
                                          AppLocalizations.of(context)!.pinCode,
                                      key_type: TextInputType.number,
                                      hintTextColor: Colors.black,
                                      bottomLineColor: Color(0xffb8b8b8),
                                    ),
                                  ),
                                  edit == false
                                      ? Container()
                                      : Container(
                                          height: Get.height * 0.055,
                                          child: blockButton(
                                            callback: () {
                                              var PinCode = pincode.text.trim();
                                              if (PinCode != '') {
                                                PinCodeGenerate(PinCode);
                                              }
                                            },
                                            width: Get.width * 0.3,
                                            widget: Text(
                                              AppLocalizations.of(context)!
                                                  .check,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.2),
                                            ),
                                            verticalPadding: 3,
                                          ),
                                        ),
                                ],
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                  // readOnly: edit == true ? false:true,
                                  enabled: edit,
                                  controller: country,
                                  key_type: TextInputType.visiblePassword,
                                  verticalContentPadding: 0,
                                  hinttext:
                                      AppLocalizations.of(context)!.country,
                                  hintTextColor: Colors.black,
                                  bottomLineColor: Color(0xffb8b8b8),
                                  maxLength: 10,
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Icon(
                                        Icons.location_on,
                                        color: appcolor.redColor,
                                      )),
                                ),
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                  // readOnly: edit == true ? false:true,
                                  enabled: edit,
                                  controller: state,
                                  key_type: TextInputType.visiblePassword,
                                  verticalContentPadding: 0,
                                  hinttext: AppLocalizations.of(context)!.state,

                                  hintTextColor: Colors.black,
                                  bottomLineColor: Color(0xffb8b8b8),
                                  maxLength: 10,
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Icon(
                                        Icons.location_on,
                                        color: appcolor.redColor,
                                      )),
                                ),
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: customtextformfield(
                                  //  readOnly: edit == true ? false:true,
                                  enabled: edit,
                                  controller: city,
                                  key_type: TextInputType.phone,
                                  verticalContentPadding: 0,
                                  hinttext: AppLocalizations.of(context)!.city,
                                  hintTextColor: Colors.black,
                                  bottomLineColor: Color(0xffb8b8b8),
                                  maxLength: 10,
                                  newIcon: Container(
                                      height: Get.height * 0.025,
                                      child: Icon(
                                        Icons.location_on,
                                        color: appcolor.redColor,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              Container(
                                height: Get.height * 0.055,
                                child: blockButton(
                                  callback: () {
                                    if (edit == true) {
                                      validate(context);
                                      if (isvalidEmail) {
                                        var Name =
                                            fullName.text.trim().toString();
                                        var Mobile = mobile.text.trim();
                                        var wNo =
                                            whatsapno.text.trim().toString();
                                        var Email =
                                            email.text.trim().toString();
                                        var Address =
                                            address.text.trim().toString();
                                        var Country =
                                            country.text.trim().toString();
                                        var PinCode =
                                            pincode.text.trim().toString();
                                        var State =
                                            state.text.trim().toString();
                                        var City = city.text.trim().toString();
                                        var DOB = dateofbirth.text.toString();
                                        var bussinesName = bussinessName.text
                                            .trim()
                                            .toString();
                                        var gender = data['gender'].toString();

                                        // if(profileImagecir == null){
                                        //   var value = {
                                        //     "name":Name,
                                        //     "email":Email,
                                        //     "mobile_no":Mobile,
                                        //     "whatsapp_number":wNo,
                                        //     "address":Address,
                                        //     "pincode": PinCode,
                                        //     "country":Country,
                                        //     "state": State,
                                        //     "city":City,
                                        //     "gender":_radioVal == ''?_radioSelected == 1?'male':'female':_radioVal,
                                        //     "dob":dateofbirth.text.toString(),
                                        //     "profile_pic":profileimageback
                                        //   };
                                        //
                                        //   Future.delayed(Duration(seconds: 4),(){
                                        //     setState(() {
                                        //       isLoading2 = false;
                                        //     });
                                        //   });
                                        //    ProfileUpdate('profileinfo',value);
                                        // }else if(profileImagecir != null){
                                        //   profilePhotoUpdate(Name, Email, Mobile, wNo, Address, PinCode, Country, State,City, _radioVal, DOB);
                                        // }
                                        profilePhotoUpdate(
                                            Name,
                                            Email,
                                            Mobile,
                                            wNo,
                                            Address,
                                            PinCode,
                                            Country,
                                            State,
                                            City,
                                            _radioVal,
                                            DOB,
                                            gender,
                                            bussinesName);
                                        setState(() {
                                          isLoading1 = true;
                                        });
                                      }
                                    }
                                    setState(() {
                                      edit = true;
                                      update = true;
                                    });
                                  },
                                  width: Get.width * 0.3,
                                  widget: isLoading1 == false
                                      ? Text(
                                          '${edit == false ? AppLocalizations.of(context)!.edit : AppLocalizations.of(context)!.update}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2),
                                        )
                                      : SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          )),
                                  verticalPadding: 3,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Future<void> UpdateTransfer(String accountNO, bankName, ifscCode, holderName,
      paytmNo, googleNo, phonepay, cancelcheck, passbookback, kyc, da) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var uri = Uri.parse(
          '${apiDomain().domain}transferinfo'); // Replace with your server's endpoint
      var request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token';
      // Check for null images before adding to the request
      if (SelectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'cancelled_cheque', SelectedImage!.path));
      }
      if (SelectedImage1 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'passbook', SelectedImage1!.path));
      }
      if (SelectedImage2 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'paytm_kyc', SelectedImage2!.path));
      }

      request.fields['Ac_number'] = '$accountNO';
      request.fields['bank_name'] = '$bankName';
      request.fields['ifsc_code'] = '$ifscCode';
      request.fields['holder_name'] = '$holderName';
      request.fields['paytm_no'] = '$paytmNo';
      request.fields['phonepay_no'] = '$phonepay';
      request.fields['googlepay_no'] = '$googleNo';

      if (da['cancelled_cheque'] != null &&
          da['passbook'] != null &&
          da['paytm_kyc'] != null) {
        request.fields['cancelled_cheque'] = '$cancelcheck';
        request.fields['passbook'] = '$passbookback';
        request.fields['paytm_kyc'] = '$kyc';
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        if (rest['status'] == true) {
          setState(() {
            transferEdit = false;
            isLoading2 = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${rest['message']}')));
        } else {
          alertBoxdialogBox(context, 'Alert', '${rest['message']}');
        }
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      } else {
        print(
            "Failed to update transfer information. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Pincode get data

  Widget TransferInfo() {
    return FutureBuilder(
        future: api().GetData('transferinfo', ''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Image.asset(apiDomain().nodataimage),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.bankaccountdetails,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              controller: bankName,
                              enabled: transferEdit,
                              gradient: appcolor.voidGradient,
                              verticalContentPadding: 0,
                              hinttext: AppLocalizations.of(context)!.bankname,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                height: Get.height * 0.025,
                                child: Image(
                                  image: AssetImage('assets/bank.png'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: transferEdit,
                              key_type: TextInputType.number,
                              controller: accounNo,
                              gradient: appcolor.voidGradient,
                              verticalContentPadding: 0,
                              maxLength: 16,
                              hinttext:
                                  AppLocalizations.of(context)!.accountnumber,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                height: Get.height * 0.025,
                                child: Image(
                                  image: AssetImage('assets/bank.png'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: transferEdit,
                              controller: ifscCode,
                              gradient: appcolor.voidGradient,
                              verticalContentPadding: 0,
                              hinttext: AppLocalizations.of(context)!.ifsccode,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                height: Get.height * 0.025,
                                child: Image(
                                  image: AssetImage('assets/bank.png'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: transferEdit,
                              controller: accontHolderName,
                              verticalContentPadding: 0,
                              hinttext: AppLocalizations.of(context)!
                                  .accountholdername,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                  height: Get.height * 0.025,
                                  child: Icon(
                                    Icons.person,
                                    color: appcolor.redColor,
                                  )),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: transferEdit,
                              key_type: TextInputType.number,
                              controller: paythmNo,
                              gradient: appcolor.voidGradient,
                              verticalContentPadding: 0,
                              hinttext:
                                  AppLocalizations.of(context)!.paytmnumber,
                              maxLength: 12,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                  height: Get.height * 0.025,
                                  child: Image.asset(
                                    'assets/phone.png',
                                    color: appcolor.redColor,
                                  )),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: transferEdit,
                              key_type: TextInputType.number,
                              controller: googlePayNo,
                              gradient: appcolor.voidGradient,
                              verticalContentPadding: 0,
                              hinttext:
                                  AppLocalizations.of(context)!.googlepaynumber,
                              maxLength: 12,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                  height: Get.height * 0.025,
                                  child: Image.asset(
                                    'assets/phone.png',
                                    color: appcolor.redColor,
                                  )),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: transferEdit,
                              key_type: TextInputType.number,
                              controller: phonePayNo,
                              maxLength: 12,
                              gradient: appcolor.voidGradient,
                              verticalContentPadding: 0,
                              hinttext:
                                  AppLocalizations.of(context)!.phonepaynumber,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                              newIcon: Container(
                                  height: Get.height * 0.025,
                                  child: Image.asset(
                                    'assets/phone.png',
                                    color: appcolor.redColor,
                                  )),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.bankdocuments,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            spacing: 10,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (transferEdit == true) {
                                        showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 80,
                                                color: appcolor.redColor,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              imagePickerCamera();
                                                            },
                                                            icon: Icon(
                                                              Icons.camera,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Camera',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              imagePicker();
                                                            },
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .file,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'File',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      // ElevatedButton(
                                                      //   child: const Text('Close BottomSheet'),
                                                      //   onPressed: () => Navigator.pop(context),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    child: Container(
                                      height: Get.height * 0.15,
                                      width: Get.width * 0.27,
                                      decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                      ),
                                      child: Center(
                                        child: SelectedImage == null
                                            ? data['cancelled_cheque'] ==
                                                        null ||
                                                    data['cancelled_cheque'] ==
                                                        ''
                                                ? Image.asset('assets/add.png')
                                                : Image.network(
                                                    '${apiDomain().imageUrl + data['cancelled_cheque'].toString()}',
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 150,
                                                  )
                                            : Image.file(
                                                SelectedImage!,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 150,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .cancelledcheque,
                                    style: TextStyle(fontSize: 14, height: 1),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (transferEdit == true) {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 80,
                                              color: appcolor.redColor,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            imagePickerCamera1();
                                                          },
                                                          icon: Icon(
                                                            Icons.camera,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Camera',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            imagePicker1();
                                                          },
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .file,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'File',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: Get.height * 0.15,
                                      width: Get.width * 0.27,
                                      decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                      ),
                                      child: Center(
                                        child: SelectedImage1 == null
                                            ? data['passbook'] == null ||
                                                    data['passbook'] == ''
                                                ? Image.asset('assets/add.png')
                                                : Image.network(
                                                    '${apiDomain().imageUrl + data['passbook'].toString()}',
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 150,
                                                  )
                                            : Image.file(
                                                SelectedImage1!,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 150,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.passbook,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (transferEdit == true) {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 80,
                                              color: appcolor.redColor,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            imagePickerCamera2();
                                                          },
                                                          icon: Icon(
                                                            Icons.camera,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Camera',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            imagePicker2();
                                                          },
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .file,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          'File',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: Get.height * 0.15,
                                      width: Get.width * 0.27,
                                      decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                      ),
                                      child: Center(
                                        child: SelectedImage2 == null
                                            ? data['paytm_kyc'] == null ||
                                                    data['paytm_kyc'] == ''
                                                ? Image.asset('assets/add.png')
                                                : Image.network(
                                                    '${apiDomain().imageUrl + data['paytm_kyc'].toString()}',
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 150,
                                                  )
                                            : Image.file(
                                                SelectedImage2!,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 150,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .paytmkycscreenshot,
                                    style: TextStyle(fontSize: 14, height: 1.1),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: blockButton(
                              callback: () {
                                if (transferEdit == true) {
                                  var AccountNO = accounNo.text.trim();
                                  var BankName =
                                      bankName.text.trim().toString();
                                  var IfscCode =
                                      ifscCode.text.trim().toString();
                                  var HolderName =
                                      accontHolderName.text.trim().toString();
                                  var PaythmNo =
                                      paythmNo.text.trim().toString();
                                  var GoogleNo =
                                      googlePayNo.text.trim().toString();
                                  var Phonepay =
                                      phonePayNo.text.trim().toString();
                                  var cancel =
                                      data['cancelled_cheque'].toString();
                                  var pass = data['passbook'].toString();
                                  var ky = data['paytm_kyc'].toString();
                                  var da = data;
                                  var valuess = {
                                    "bank_name": BankName,
                                    "Ac_number": AccountNO,
                                    "ifsc_code": IfscCode,
                                    "holder_name": HolderName,
                                    "paytm_no": PaythmNo,
                                    "googlepay_no": GoogleNo,
                                    "phonepay_no": Phonepay,
                                  };
                                  UpdateTransfer(
                                      AccountNO,
                                      BankName,
                                      IfscCode,
                                      HolderName,
                                      PaythmNo,
                                      GoogleNo,
                                      Phonepay,
                                      cancel,
                                      pass,
                                      ky,
                                      da);
                                  setState(() {
                                    isLoading2 = true;
                                  });
                                }
                                setState(() {
                                  transferEdit = true;
                                });
                              },
                              width: Get.width * 0.3,
                              widget: isLoading2 == false
                                  ? Text(
                                      '${transferEdit == true ? 'Update' : AppLocalizations.of(context)!.edit}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2),
                                    )
                                  : SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))),
                              verticalPadding: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> dealerupdate(String accountNO, gstNo, aadharNumber, front, back,
      gstimaage, panimage, shopimage, da) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var uri = Uri.parse(
          '${apiDomain().domain}documentinfo'); // Replace with your server's endpoint

      var request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token';

      // Add images to the request
      if (SelectedImage3 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'aadhar_front', SelectedImage3!.path));
      }
      if (SelectedImage4 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'aadhar_back', SelectedImage4!.path));
      }
      if (SelectedImage5 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'pan_card', SelectedImage5!.path));
      }
      request.fields['pan_no'] = '$accountNO';
      request.fields['aadhar_no'] = '$aadharNumber';
      if (da['aadhar_front'] != null &&
          da['aadhar_back'] != null &&
          da['pan_card'] != null) {
        request.fields['aadhar_front'] = '$front';
        request.fields['aadhar_back'] = '$back';
        request.fields['pan_card'] = '$panimage';
      }

      // if(SelectedImage3 == null ){
      //   request.fields['aadhar_front'] =  '$front';
      // }
      // if(SelectedImage4 == null ){
      //   request.fields['aadhar_back'] =  '$back';
      // }
      // if(SelectedImage5 == null ){
      //   request.fields['pan_card'] =  '$panimage';
      // }
      // request.fields
      //   ..['pan_no'] = '$accountNO'
      //   ..['aadhar_no'] = '$aadharNumber'
      //   ..['aadhar_front'] = '$front'
      //   ..['aadhar_back'] = '$back'
      //   ..['pan_card'] = '$panimage'
      //   ..['gst_no'] = '$gstNo';
      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        if (rest['status'] == true) {
          setState(() {
            documentEdit = false;
            isLoading4 = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${rest['message']}')));
        } else {
          alertBoxdialogBox(context, 'Alert', '${rest['message']}');
        }
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      } else {
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> PanDocumentInfoupload(String accountNO, gstNo, aadharNumber,
      front, back, gstimaage, panimage, shopimage, da) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var uri = Uri.parse(
          '${apiDomain().domain}documentinfo'); // Replace with your server's endpoint

      var request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token';
      // Add images to the request

      if (SelectedImage3 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'aadhar_front', SelectedImage3!.path));
      }
      if (SelectedImage4 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'aadhar_back', SelectedImage4!.path));
      }
      if (SelectedImage5 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'pan_card', SelectedImage5!.path));
      }
      if (SelectedImage6 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'gst_certificate', SelectedImage6!.path));
      }
      if (SelectedImage7 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'shop_image', SelectedImage7!.path));
      }
      request.fields['pan_no'] = '$accountNO';
      request.fields['aadhar_no'] = '$aadharNumber';
      request.fields['gst_no'] = '$gstNo';
      if (da['aadhar_front'] != null &&
          da['aadhar_back'] != null &&
          da['pan_card'] != null &&
          da['gst_certificate'] != null &&
          da['shop_image'] != null) {
        request.fields['aadhar_front'] = '$front';
        request.fields['aadhar_back'] = '$back';
        request.fields['pan_card'] = '$panimage';
        request.fields['gst_certificate'] = '$gstimaage';
        request.fields['shop_image'] = '$shopimage';
      }

      // if(SelectedImage3 == null ){
      //   request.fields['aadhar_front'] =  '$front';
      // }
      // if(SelectedImage4 == null ){
      //   request.fields['aadhar_back'] =  '$back';
      // }
      // if(SelectedImage5 == null ){
      //   request.fields['pan_card'] =  '$panimage';
      // }
      // if(SelectedImage6 == null ){
      //   request.fields['gst_certificate'] =  '$gstimaage';
      // }
      // if(SelectedImage7 == null ){
      //   request.fields['shop_image'] =  '$shopimage';
      // }
      // request.fields
      //   ..['pan_no'] = '$accountNO'
      //   ..['aadhar_no'] = '$aadharNumber'
      //   ..['aadhar_front'] = '$front'
      //   ..['aadhar_back'] = '$back'
      //   ..['pan_card'] = '$panimage'
      //   ..['gst_certificate'] = '$gstimaage'
      //   ..['shop_image'] = '$shopimage'
      //   ..['gst_no'] = '$gstNo';
      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        if (rest['status'] == true) {
          setState(() {
            documentEdit = false;
            isLoading4 = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${rest['message']}')));
        } else {
          alertBoxdialogBox(context, 'Alert', '${rest['message']}');
        }
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      } else {
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget Documents() {
    return SafeArea(
      child: FutureBuilder(
          future: api().GetData('documentinfo', ''),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Image.asset(apiDomain().nodataimage),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data[index];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              AppLocalizations.of(context)!.aadhardetails,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              height: Get.height * 0.055,
                              child: customtextformfield(
                                enabled: documentEdit,
                                maxLength: 12,
                                controller: aadharno,
                                gradient: appcolor.voidGradient,
                                verticalContentPadding: 0,
                                hinttext:
                                    AppLocalizations.of(context)!.aadharnumber,
                                hintTextColor: Colors.black,
                                bottomLineColor: Color(0xffb8b8b8),
                                key_type: TextInputType.number,
                                newIcon: Container(
                                  height: Get.height * 0.025,
                                  child: Image(
                                    image: AssetImage('assets/acctDetails.png'),
                                  ),
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: Get.height * 0.18,
                                      width: Get.width * 0.2,
                                      child: Center(
                                          child: Text(
                                        '${AppLocalizations.of(context)!.upload}\n${AppLocalizations.of(context)!.aadhar}\n${AppLocalizations.of(context)!.card}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (documentEdit == true) {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 80,
                                                color: appcolor.redColor,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              aadharFrontcamer();
                                                            },
                                                            icon: Icon(
                                                              Icons.camera,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Camera',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              aadharFront();
                                                            },
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .file,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'File',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: Get.height * 0.18,
                                        width: Get.width * 0.3,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                        ),
                                        child: Center(
                                          child: SelectedImage3 == null
                                              ? data['aadhar_front'] == null ||
                                                      data['aadhar_front'] == ''
                                                  ? Image.asset(
                                                      'assets/add.png')
                                                  : Image.network(
                                                      '${apiDomain().imageUrl + data['aadhar_front'].toString()}',
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 150,
                                                    )
                                              : Image.file(
                                                  SelectedImage3!,
                                                  fit: BoxFit.cover,
                                                  width: 120,
                                                  height: 150,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.forntside,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (documentEdit == true) {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 80,
                                                color: appcolor.redColor,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              aadharbackCamera();
                                                            },
                                                            icon: Icon(
                                                              Icons.camera,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Camera',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              aadharback();
                                                            },
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .file,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'File',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: Get.height * 0.18,
                                        width: Get.width * 0.3,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                        ),
                                        child: Center(
                                          child: SelectedImage4 == null
                                              ? data['aadhar_back'] == null ||
                                                      data['aadhar_back'] == ''
                                                  ? Image.asset(
                                                      'assets/add.png')
                                                  : Image.network(
                                                      '${apiDomain().imageUrl + data['aadhar_back'].toString()}',
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 150,
                                                    )
                                              : Image.file(
                                                  SelectedImage4!,
                                                  fit: BoxFit.cover,
                                                  width: 120,
                                                  height: 150,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.backside,
                                      style: TextStyle(fontSize: 14, height: 0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Container(
                              height: Get.height * 0.055,
                              child: customtextformfield(
                                enabled: documentEdit,
                                controller: panNumber,
                                gradient: appcolor.voidGradient,
                                verticalContentPadding: 0,
                                key_type: TextInputType.name,
                                hinttext:
                                    AppLocalizations.of(context)!.pannumber,
                                textCapitalization: true,
                                maxLength: 10,
                                hintTextColor: Colors.black,
                                bottomLineColor: Color(0xffb8b8b8),
                                newIcon: Container(
                                  height: Get.height * 0.025,
                                  child: Image(
                                    image: AssetImage('assets/acctDetails.png'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .uploadpancard,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (documentEdit == true) {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 80,
                                                color: appcolor.redColor,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              pancardcamera();
                                                            },
                                                            icon: Icon(
                                                              Icons.camera,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Camera',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              pancard();
                                                            },
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .file,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'File',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),

                                                      // ElevatedButton(
                                                      //   child: const Text('Close BottomSheet'),
                                                      //   onPressed: () => Navigator.pop(context),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: Get.height * 0.15,
                                        width: Get.width * 0.45,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                        ),
                                        child: Center(
                                          child: SelectedImage5 == null
                                              ? data['pan_card'] == null ||
                                                      data['pan_card'] == ''
                                                  ? Image.asset(
                                                      'assets/add.png')
                                                  : Image.network(
                                                      '${apiDomain().imageUrl + data['pan_card'].toString()}',
                                                      fit: BoxFit.cover,
                                                      width: 160,
                                                      height: 150,
                                                    )
                                              : Image.file(
                                                  SelectedImage5!,
                                                  fit: BoxFit.cover,
                                                  width: 160,
                                                  height: 150,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                data['profession'] == 'electrician'
                                    ? Container()
                                    : Column(
                                        children: [
                                          Container(
                                            height: Get.height * 0.055,
                                            child: customtextformfield(
                                              enabled: documentEdit,
                                              controller: GstNumber,
                                              gradient: appcolor.voidGradient,
                                              verticalContentPadding: 0,
                                              key_type: TextInputType.name,
                                              hinttext: 'Gst Number',
                                              maxLength: 15,
                                              hintTextColor: Colors.black,
                                              textCapitalization: true,
                                              bottomLineColor:
                                                  Color(0xffb8b8b8),
                                              newIcon: Container(
                                                height: Get.height * 0.025,
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/acctDetails.png'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'GST Certificate\nUpload',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                width: 27,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (documentEdit == true) {
                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: 80,
                                                          color:
                                                              appcolor.redColor,
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <Widget>[
                                                                Column(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        gstcamera();
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .camera,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Camera',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 40,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        gstupload();
                                                                      },
                                                                      icon:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .file,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'File',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ],
                                                                ),

                                                                // ElevatedButton(
                                                                //   child: const Text('Close BottomSheet'),
                                                                //   onPressed: () => Navigator.pop(context),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: Get.height * 0.15,
                                                  width: Get.width * 0.45,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffD9D9D9),
                                                  ),
                                                  child: Center(
                                                    child: SelectedImage6 ==
                                                            null
                                                        ? data['gst_certificate'] ==
                                                                    null ||
                                                                data['gst_certificate'] ==
                                                                    ''
                                                            ? Image.asset(
                                                                'assets/add.png')
                                                            : Image.network(
                                                                '${apiDomain().imageUrl + data['gst_certificate'].toString()}',
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 160,
                                                                height: 150,
                                                              )
                                                        : Image.file(
                                                            SelectedImage6!,
                                                            fit: BoxFit.cover,
                                                            width: 160,
                                                            height: 150,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ).marginOnly(top: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Shop Image      ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                width: 27,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (documentEdit == true) {
                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: 80,
                                                          color:
                                                              appcolor.redColor,
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <Widget>[
                                                                Column(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        shopcamera();
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .camera,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Camera',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 40,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        shopImage();
                                                                      },
                                                                      icon:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .file,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'File',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ],
                                                                ),

                                                                // ElevatedButton(
                                                                //   child: const Text('Close BottomSheet'),
                                                                //   onPressed: () => Navigator.pop(context),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: Get.height * 0.15,
                                                  width: Get.width * 0.45,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffD9D9D9),
                                                  ),
                                                  child: Center(
                                                    child: SelectedImage7 ==
                                                            null
                                                        ? data['shop_image'] ==
                                                                    null ||
                                                                data['shop_image'] ==
                                                                    ''
                                                            ? Image.asset(
                                                                'assets/add.png')
                                                            : Image.network(
                                                                '${apiDomain().imageUrl + data['shop_image'].toString()}',
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 160,
                                                                height: 150,
                                                              )
                                                        : Image.file(
                                                            SelectedImage7!,
                                                            fit: BoxFit.cover,
                                                            width: 160,
                                                            height: 150,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ).marginOnly(top: 10),
                                        ],
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Container(
                              height: Get.height * 0.055,
                              child: blockButton(
                                callback: () {
                                  if (documentEdit == true) {
                                    var Pan = panNumber.text.trim().toString();
                                    var Gstno =
                                        GstNumber.text.trim().toString();
                                    var Aadharno = aadharno.text.trim();
                                    var imagefront =
                                        data['aadhar_front'].toString();
                                    var imageback =
                                        data['aadhar_back'].toString();
                                    var pancarimage =
                                        data['pan_card'].toString();
                                    var gstimage =
                                        data['gst_certificate'].toString();
                                    var shopimage =
                                        data['shop_image'].toString();
                                    var da = data;

                                    // if(SelectedImage3 == null && SelectedImage4 == null && SelectedImage5 == null && SelectedImage6 == null && SelectedImage7 == null){
                                    //   setState(() {
                                    //     isLoading4 =true;
                                    //   });
                                    //   Future.delayed(Duration(seconds: 2),(){
                                    //     setState(() {
                                    //       isLoading4 = false;
                                    //     });
                                    //   });
                                    //   var value = {
                                    //     "pan_no":Pan,
                                    //     "gst_no":Gstno,
                                    //     "aadhar_no":Aadharno
                                    //   };
                                    //   ProfileUpdate('documentinfo',value);
                                    // }else{
                                    //   setState(() {
                                    //     isLoading4 =true;
                                    //   });
                                    //   Future.delayed(Duration(seconds: 2),(){
                                    //     setState(() {
                                    //       isLoading4 = false;
                                    //     });
                                    //   });
                                    //
                                    // }
                                    setState(() {
                                      isLoading4 = true;
                                    });

                                    if (SelectedImage6 == null &&
                                        SelectedImage7 == null) {
                                      dealerupdate(
                                          Pan,
                                          Gstno,
                                          Aadharno,
                                          imagefront,
                                          imageback,
                                          gstimage,
                                          pancarimage,
                                          shopimage,
                                          da);
                                    } else {
                                      PanDocumentInfoupload(
                                          Pan,
                                          Gstno,
                                          Aadharno,
                                          imagefront,
                                          imageback,
                                          gstimage,
                                          pancarimage,
                                          shopimage,
                                          da);
                                    }
                                  }
                                  setState(() {
                                    documentEdit = true;
                                  });
                                },
                                width: Get.width * 0.3,
                                widget: isLoading4 == false
                                    ? Text(
                                        '${documentEdit == true ? 'Update' : AppLocalizations.of(context)!.edit}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2),
                                      )
                                    : SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                verticalPadding: 3,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget AdditionalInfo() {
    var bloodgroups;
    return FutureBuilder(
        future: api().GetData('aditionalinfo', ''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Image.asset(apiDomain().nodataimage),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            AppLocalizations.of(context)!.fillDetails,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1,
                            ),
                          ),
                          additionEdit == true
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.nationality}:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      height: Get.height * 0.05,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xffb8b8b8),
                                          ),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration.collapsed(
                                            hintText:
                                                '${nationality == null ? 'Nationality' : nationality}',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              height: 2.5,
                                            ),
                                          ),
                                          value: value,
                                          onChanged: (value) {
                                            Nationalityd = value.toString();
                                          },
                                          items: [
                                            DropdownMenuItem(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .india,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              value: 1,
                                            ),
                                            DropdownMenuItem(
                                                child: Text(
                                                  'Nepal',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                value: 2),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.nationality}:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      height: Get.height * 0.055,
                                      child: customtextformfield(
                                        enabled: additionEdit,
                                        readOnly: true,
                                        verticalContentPadding: 0,
                                        hinttext:
                                            '${nationality == null ? 'Nationality' : nationality}',
                                        hintTextColor: Colors.black,
                                        bottomLineColor: Color(0xffb8b8b8),
                                      ),
                                    ),
                                  ],
                                ),
                          additionEdit == true
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.marriageStatus}:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      height: Get.height * 0.05,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xffb8b8b8),
                                          ),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration.collapsed(
                                            hintText:
                                                '${marriedstaus == null ? 'Marital Status' : marriedstaus}',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              height: 2.5,
                                            ),
                                          ),
                                          value: value,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue.value =
                                                  value.toString();
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .married,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              value: 1,
                                            ),
                                            DropdownMenuItem(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .unmmaried,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                value: 2),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.marriageStatus}:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      height: Get.height * 0.055,
                                      child: customtextformfield(
                                        enabled: additionEdit,
                                        readOnly: true,
                                        verticalContentPadding: 0,
                                        hinttext:
                                            '${marriedstaus == null ? 'Married Status' : marriedstaus}',
                                        hintTextColor: Colors.black,
                                        bottomLineColor: Color(0xffb8b8b8),
                                      ),
                                    ),
                                  ],
                                ),
                          additionEdit == false
                              ? marriedstaus == 'Married'
                                  ? groupValue.value == '1'
                                      ? Column(
                                          children: [
                                            Container(
                                              height: Get.height * 0.055,
                                              //  width: Get.width * 0.45,
                                              child: customtextformfield(
                                                  enabled: additionEdit,
                                                  controller: anniversy,
                                                  readOnly: true,
                                                  callback: () async {
                                                    if (additionEdit == true) {
                                                      anniversy.text =
                                                          await profileController
                                                              .showdatepicker(
                                                                  context);
                                                    }
                                                  },
                                                  key_type:
                                                      TextInputType.datetime,
                                                  hinttext: 'Anniversary Date',
                                                  hintTextColor: Colors.black,
                                                  newIcon: Container(
                                                      height:
                                                          Get.height * 0.025,
                                                      child: Image.asset(
                                                        'assets/birthdate.png',
                                                        color:
                                                            appcolor.redColor,
                                                      )),
                                                  bottomLineColor:
                                                      Color(0xffb8b8b8)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Children Info',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1,
                                                  ),
                                                ),
                                              ],
                                            ).paddingSymmetric(horizontal: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Radio(
                                                      value: 0,
                                                      groupValue:
                                                          radioSelectedd,
                                                      activeColor: Colors.red,
                                                      onChanged: (value) {
                                                        if (additionEdit ==
                                                            true) {
                                                          setState(() {
                                                            radioSelectedd =
                                                                int.parse(value
                                                                    .toString());
                                                            radioVall = '0';
                                                            //  print(_radioVal);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    const Text("0"),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Radio(
                                                      value: 1,
                                                      groupValue:
                                                          radioSelectedd,
                                                      activeColor: Colors.red,
                                                      onChanged: (value) {
                                                        if (additionEdit ==
                                                            true) {
                                                          setState(() {
                                                            radioSelectedd =
                                                                int.parse(value
                                                                    .toString());
                                                            radioVall = '1';
                                                            //  print(_radioVal);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    const Text("1"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 2,
                                                      groupValue:
                                                          radioSelectedd,
                                                      activeColor: Colors.red,
                                                      onChanged: (value) {
                                                        if (additionEdit ==
                                                            true) {
                                                          setState(() {
                                                            radioSelectedd =
                                                                int.parse(value
                                                                    .toString());
                                                            radioVall = '2';
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    const Text("2"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 3,
                                                      groupValue:
                                                          radioSelectedd,
                                                      activeColor: Colors.red,
                                                      onChanged: (value) {
                                                        if (additionEdit ==
                                                            true) {
                                                          setState(() {
                                                            radioSelectedd =
                                                                int.parse(value
                                                                    .toString());
                                                            radioVall = '3';
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    const Text("3"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            radioSelectedd == 1
                                                ? Column(
                                                    children: [
                                                      //Text('First Child Info',style: TextStyle(fontSize: 16),),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            width: Get.width *
                                                                0.45,
                                                            child: customtextformfield(
                                                                enabled:
                                                                    additionEdit,
                                                                controller:
                                                                    firstname,
                                                                hinttext:
                                                                    'Name',
                                                                hintTextColor:
                                                                    Colors
                                                                        .black,
                                                                bottomLineColor:
                                                                    Color(
                                                                        0xffb8b8b8)),
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            width: Get.width *
                                                                0.45,
                                                            child:
                                                                customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        firstdob,
                                                                    readOnly:
                                                                        true,
                                                                    callback:
                                                                        () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        firstdob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type:
                                                                        TextInputType
                                                                            .datetime,
                                                                    hinttext:
                                                                        'Birth Date',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    newIcon:
                                                                        Container(
                                                                            height: Get.height *
                                                                                0.025,
                                                                            child: Image
                                                                                .asset(
                                                                              'assets/birthdate.png',
                                                                              color: appcolor.redColor,
                                                                            )),
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height:
                                                            Get.height * 0.055,
                                                        child:
                                                            customtextformfield(
                                                          enabled: additionEdit,
                                                          controller:
                                                              studyfirst,
                                                          verticalContentPadding:
                                                              0,
                                                          hinttext: 'Study In',
                                                          hintTextColor:
                                                              Colors.black,
                                                          bottomLineColor:
                                                              Color(0xffb8b8b8),
                                                          // newIcon: Container(
                                                          //   height: Get.height * 0.025,
                                                          //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : radioSelectedd == 2
                                                    ? Column(
                                                        children: [
                                                          // Text('First Child Info',style: TextStyle(fontSize: 15),),
                                                          // Text('First Child Info',style: TextStyle(fontSize: 15,color: appcolor.redColor),),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        firstname,
                                                                    hinttext:
                                                                        '1st Name',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled: additionEdit,
                                                                    controller: firstdob,
                                                                    readOnly: true,
                                                                    callback: () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        firstdob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type: TextInputType.datetime,
                                                                    hinttext: '1st Birth Date',
                                                                    hintTextColor: Colors.black,
                                                                    newIcon: Container(
                                                                        height: Get.height * 0.025,
                                                                        child: Image.asset(
                                                                          'assets/birthdate.png',
                                                                          color:
                                                                              appcolor.redColor,
                                                                        )),
                                                                    bottomLineColor: Color(0xffb8b8b8)),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            child:
                                                                customtextformfield(
                                                              enabled:
                                                                  additionEdit,
                                                              controller:
                                                                  studyfirst,
                                                              verticalContentPadding:
                                                                  0,
                                                              hinttext:
                                                                  '1st Study In',
                                                              hintTextColor:
                                                                  Colors.black,
                                                              bottomLineColor:
                                                                  Color(
                                                                      0xffb8b8b8),
                                                              // newIcon: Container(
                                                              //   height: Get.height * 0.025,
                                                              //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                              // ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        secondname,
                                                                    hinttext:
                                                                        '2nd Name',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled: additionEdit,
                                                                    controller: seconddob,
                                                                    readOnly: true,
                                                                    callback: () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        seconddob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type: TextInputType.datetime,
                                                                    hinttext: '2nd Birth Date',
                                                                    hintTextColor: Colors.black,
                                                                    newIcon: Container(
                                                                        height: Get.height * 0.025,
                                                                        child: Image.asset(
                                                                          'assets/birthdate.png',
                                                                          color:
                                                                              appcolor.redColor,
                                                                        )),
                                                                    bottomLineColor: Color(0xffb8b8b8)),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            child:
                                                                customtextformfield(
                                                              enabled:
                                                                  additionEdit,
                                                              controller:
                                                                  secondstudyin,
                                                              verticalContentPadding:
                                                                  0,
                                                              hinttext:
                                                                  '2nd Study In',
                                                              hintTextColor:
                                                                  Colors.black,
                                                              bottomLineColor:
                                                                  Color(
                                                                      0xffb8b8b8),
                                                              // newIcon: Container(
                                                              //   height: Get.height * 0.025,
                                                              //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                              // ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : radioSelectedd == 3
                                                        ? Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    width:
                                                                        Get.width *
                                                                            0.45,
                                                                    child: customtextformfield(
                                                                        enabled:
                                                                            additionEdit,
                                                                        controller:
                                                                            firstname,
                                                                        hinttext:
                                                                            '1st Name',
                                                                        hintTextColor:
                                                                            Colors
                                                                                .black,
                                                                        bottomLineColor:
                                                                            Color(0xffb8b8b8)),
                                                                  ),
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    width:
                                                                        Get.width *
                                                                            0.45,
                                                                    child: customtextformfield(
                                                                        enabled: additionEdit,
                                                                        controller: firstdob,
                                                                        readOnly: true,
                                                                        callback: () async {
                                                                          if (additionEdit ==
                                                                              true) {
                                                                            firstdob.text =
                                                                                await profileController.showdatepicker(context);
                                                                          }
                                                                        },
                                                                        key_type: TextInputType.datetime,
                                                                        hinttext: '1st Birth Date',
                                                                        hintTextColor: Colors.black,
                                                                        newIcon: Container(
                                                                            height: Get.height * 0.025,
                                                                            child: Image.asset(
                                                                              'assets/birthdate.png',
                                                                              color: appcolor.redColor,
                                                                            )),
                                                                        bottomLineColor: Color(0xffb8b8b8)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                child:
                                                                    customtextformfield(
                                                                  enabled:
                                                                      additionEdit,
                                                                  controller:
                                                                      studyfirst,
                                                                  verticalContentPadding:
                                                                      0,
                                                                  hinttext:
                                                                      '1st Study In',
                                                                  hintTextColor:
                                                                      Colors
                                                                          .black,
                                                                  bottomLineColor:
                                                                      Color(
                                                                          0xffb8b8b8),
                                                                  // newIcon: Container(
                                                                  //   height: Get.height * 0.025,
                                                                  //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                                  // ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    width:
                                                                        Get.width *
                                                                            0.45,
                                                                    child: customtextformfield(
                                                                        enabled:
                                                                            additionEdit,
                                                                        controller:
                                                                            secondname,
                                                                        hinttext:
                                                                            '2nd Name',
                                                                        hintTextColor:
                                                                            Colors
                                                                                .black,
                                                                        bottomLineColor:
                                                                            Color(0xffb8b8b8)),
                                                                  ),
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    width:
                                                                        Get.width *
                                                                            0.45,
                                                                    child: customtextformfield(
                                                                        enabled: additionEdit,
                                                                        controller: seconddob,
                                                                        readOnly: true,
                                                                        callback: () async {
                                                                          if (additionEdit ==
                                                                              true) {
                                                                            seconddob.text =
                                                                                await profileController.showdatepicker(context);
                                                                          }
                                                                        },
                                                                        key_type: TextInputType.datetime,
                                                                        hinttext: '2nd Birth Date',
                                                                        hintTextColor: Colors.black,
                                                                        newIcon: Container(
                                                                            height: Get.height * 0.025,
                                                                            child: Image.asset(
                                                                              'assets/birthdate.png',
                                                                              color: appcolor.redColor,
                                                                            )),
                                                                        bottomLineColor: Color(0xffb8b8b8)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                child:
                                                                    customtextformfield(
                                                                  enabled:
                                                                      additionEdit,
                                                                  controller:
                                                                      secondstudyin,
                                                                  verticalContentPadding:
                                                                      0,
                                                                  hinttext:
                                                                      '2nd Study In',
                                                                  hintTextColor:
                                                                      Colors
                                                                          .black,
                                                                  bottomLineColor:
                                                                      Color(
                                                                          0xffb8b8b8),
                                                                  // newIcon: Container(
                                                                  //   height: Get.height * 0.025,
                                                                  //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                                  // ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    width:
                                                                        Get.width *
                                                                            0.45,
                                                                    child: customtextformfield(
                                                                        enabled:
                                                                            additionEdit,
                                                                        controller:
                                                                            thrdname,
                                                                        hinttext:
                                                                            '3rd Name',
                                                                        hintTextColor:
                                                                            Colors
                                                                                .black,
                                                                        bottomLineColor:
                                                                            Color(0xffb8b8b8)),
                                                                  ),
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    width:
                                                                        Get.width *
                                                                            0.45,
                                                                    child: customtextformfield(
                                                                        enabled: additionEdit,
                                                                        controller: thrddob,
                                                                        readOnly: true,
                                                                        callback: () async {
                                                                          if (additionEdit ==
                                                                              true) {
                                                                            thrddob.text =
                                                                                await profileController.showdatepicker(context);
                                                                          }
                                                                        },
                                                                        key_type: TextInputType.datetime,
                                                                        hinttext: '3rd Birth Date',
                                                                        hintTextColor: Colors.black,
                                                                        newIcon: Container(
                                                                            height: Get.height * 0.025,
                                                                            child: Image.asset(
                                                                              'assets/birthdate.png',
                                                                              color: appcolor.redColor,
                                                                            )),
                                                                        bottomLineColor: Color(0xffb8b8b8)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                child:
                                                                    customtextformfield(
                                                                  enabled:
                                                                      additionEdit,
                                                                  controller:
                                                                      thrdstudy,
                                                                  verticalContentPadding:
                                                                      0,
                                                                  hinttext:
                                                                      '3rd Study In',
                                                                  hintTextColor:
                                                                      Colors
                                                                          .black,
                                                                  bottomLineColor:
                                                                      Color(
                                                                          0xffb8b8b8),
                                                                  // newIcon: Container(
                                                                  //   height: Get.height * 0.025,
                                                                  //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                                  // ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container()
                                          ],
                                        )
                                      : SizedBox(
                                          height: 20,
                                        )
                                  : Container()
                              : groupValue.value == '1'
                                  ? Column(
                                      children: [
                                        Container(
                                          height: Get.height * 0.055,
                                          //  width: Get.width * 0.45,
                                          child: customtextformfield(
                                              enabled: additionEdit,
                                              controller: anniversy,
                                              readOnly: true,
                                              callback: () async {
                                                if (additionEdit == true) {
                                                  anniversy.text =
                                                      await profileController
                                                          .showdatepicker(
                                                              context);
                                                }
                                              },
                                              key_type: TextInputType.datetime,
                                              hinttext: 'Anniversary Date',
                                              hintTextColor: Colors.black,
                                              newIcon: Container(
                                                  height: Get.height * 0.025,
                                                  child: Image.asset(
                                                    'assets/birthdate.png',
                                                    color: appcolor.redColor,
                                                  )),
                                              bottomLineColor:
                                                  Color(0xffb8b8b8)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Children Info',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  value: 0,
                                                  groupValue: radioSelectedd,
                                                  activeColor: Colors.red,
                                                  onChanged: (value) {
                                                    if (additionEdit == true) {
                                                      setState(() {
                                                        radioSelectedd =
                                                            int.parse(value
                                                                .toString());
                                                        radioVall = '0';
                                                        //  print(_radioVal);
                                                      });
                                                    }
                                                  },
                                                ),
                                                const Text("0"),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  value: 1,
                                                  groupValue: radioSelectedd,
                                                  activeColor: Colors.red,
                                                  onChanged: (value) {
                                                    if (additionEdit == true) {
                                                      setState(() {
                                                        radioSelectedd =
                                                            int.parse(value
                                                                .toString());
                                                        radioVall = '1';
                                                        //  print(_radioVal);
                                                      });
                                                    }
                                                  },
                                                ),
                                                const Text("1"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 2,
                                                  groupValue: radioSelectedd,
                                                  activeColor: Colors.red,
                                                  onChanged: (value) {
                                                    if (additionEdit == true) {
                                                      setState(() {
                                                        radioSelectedd =
                                                            int.parse(value
                                                                .toString());
                                                        radioVall = '2';
                                                      });
                                                    }
                                                  },
                                                ),
                                                const Text("2"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 3,
                                                  groupValue: radioSelectedd,
                                                  activeColor: Colors.red,
                                                  onChanged: (value) {
                                                    if (additionEdit == true) {
                                                      setState(() {
                                                        radioSelectedd =
                                                            int.parse(value
                                                                .toString());
                                                        radioVall = '3';
                                                      });
                                                    }
                                                  },
                                                ),
                                                const Text("3"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        radioSelectedd == 1
                                            ? Column(
                                                children: [
                                                  //Text('First Child Info',style: TextStyle(fontSize: 16),),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height:
                                                            Get.height * 0.055,
                                                        width: Get.width * 0.45,
                                                        child: customtextformfield(
                                                            enabled:
                                                                additionEdit,
                                                            controller:
                                                                firstname,
                                                            hinttext: 'Name',
                                                            hintTextColor:
                                                                Colors.black,
                                                            bottomLineColor:
                                                                Color(
                                                                    0xffb8b8b8)),
                                                      ),
                                                      Container(
                                                        height:
                                                            Get.height * 0.055,
                                                        width: Get.width * 0.45,
                                                        child:
                                                            customtextformfield(
                                                                enabled:
                                                                    additionEdit,
                                                                controller:
                                                                    firstdob,
                                                                readOnly: true,
                                                                callback:
                                                                    () async {
                                                                  if (additionEdit ==
                                                                      true) {
                                                                    firstdob.text =
                                                                        await profileController
                                                                            .showdatepicker(context);
                                                                  }
                                                                },
                                                                key_type:
                                                                    TextInputType
                                                                        .datetime,
                                                                hinttext:
                                                                    'Birth Date',
                                                                hintTextColor:
                                                                    Colors
                                                                        .black,
                                                                newIcon:
                                                                    Container(
                                                                        height: Get.height *
                                                                            0.025,
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/birthdate.png',
                                                                          color:
                                                                              appcolor.redColor,
                                                                        )),
                                                                bottomLineColor:
                                                                    Color(
                                                                        0xffb8b8b8)),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: Get.height * 0.055,
                                                    child: customtextformfield(
                                                      enabled: additionEdit,
                                                      controller: studyfirst,
                                                      verticalContentPadding: 0,
                                                      hinttext: 'Study In',
                                                      hintTextColor:
                                                          Colors.black,
                                                      bottomLineColor:
                                                          Color(0xffb8b8b8),
                                                      // newIcon: Container(
                                                      //   height: Get.height * 0.025,
                                                      //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                      // ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : radioSelectedd == 2
                                                ? Column(
                                                    children: [
                                                      // Text('First Child Info',style: TextStyle(fontSize: 15),),
                                                      // Text('First Child Info',style: TextStyle(fontSize: 15,color: appcolor.redColor),),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            width: Get.width *
                                                                0.45,
                                                            child: customtextformfield(
                                                                enabled:
                                                                    additionEdit,
                                                                controller:
                                                                    firstname,
                                                                hinttext:
                                                                    '1st Name',
                                                                hintTextColor:
                                                                    Colors
                                                                        .black,
                                                                bottomLineColor:
                                                                    Color(
                                                                        0xffb8b8b8)),
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            width: Get.width *
                                                                0.45,
                                                            child:
                                                                customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        firstdob,
                                                                    readOnly:
                                                                        true,
                                                                    callback:
                                                                        () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        firstdob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type:
                                                                        TextInputType
                                                                            .datetime,
                                                                    hinttext:
                                                                        '1st Birth Date',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    newIcon:
                                                                        Container(
                                                                            height: Get.height *
                                                                                0.025,
                                                                            child: Image
                                                                                .asset(
                                                                              'assets/birthdate.png',
                                                                              color: appcolor.redColor,
                                                                            )),
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height:
                                                            Get.height * 0.055,
                                                        child:
                                                            customtextformfield(
                                                          enabled: additionEdit,
                                                          controller:
                                                              studyfirst,
                                                          verticalContentPadding:
                                                              0,
                                                          hinttext:
                                                              '1st Study In',
                                                          hintTextColor:
                                                              Colors.black,
                                                          bottomLineColor:
                                                              Color(0xffb8b8b8),
                                                          // newIcon: Container(
                                                          //   height: Get.height * 0.025,
                                                          //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                          // ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            width: Get.width *
                                                                0.45,
                                                            child: customtextformfield(
                                                                enabled:
                                                                    additionEdit,
                                                                controller:
                                                                    secondname,
                                                                hinttext:
                                                                    '2nd Name',
                                                                hintTextColor:
                                                                    Colors
                                                                        .black,
                                                                bottomLineColor:
                                                                    Color(
                                                                        0xffb8b8b8)),
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            width: Get.width *
                                                                0.45,
                                                            child:
                                                                customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        seconddob,
                                                                    readOnly:
                                                                        true,
                                                                    callback:
                                                                        () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        seconddob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type:
                                                                        TextInputType
                                                                            .datetime,
                                                                    hinttext:
                                                                        '2nd Birth Date',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    newIcon:
                                                                        Container(
                                                                            height: Get.height *
                                                                                0.025,
                                                                            child: Image
                                                                                .asset(
                                                                              'assets/birthdate.png',
                                                                              color: appcolor.redColor,
                                                                            )),
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height:
                                                            Get.height * 0.055,
                                                        child:
                                                            customtextformfield(
                                                          enabled: additionEdit,
                                                          controller:
                                                              secondstudyin,
                                                          verticalContentPadding:
                                                              0,
                                                          hinttext:
                                                              '2nd Study In',
                                                          hintTextColor:
                                                              Colors.black,
                                                          bottomLineColor:
                                                              Color(0xffb8b8b8),
                                                          // newIcon: Container(
                                                          //   height: Get.height * 0.025,
                                                          //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : radioSelectedd == 3
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        firstname,
                                                                    hinttext:
                                                                        '1st Name',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled: additionEdit,
                                                                    controller: firstdob,
                                                                    readOnly: true,
                                                                    callback: () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        firstdob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type: TextInputType.datetime,
                                                                    hinttext: '1st Birth Date',
                                                                    hintTextColor: Colors.black,
                                                                    newIcon: Container(
                                                                        height: Get.height * 0.025,
                                                                        child: Image.asset(
                                                                          'assets/birthdate.png',
                                                                          color:
                                                                              appcolor.redColor,
                                                                        )),
                                                                    bottomLineColor: Color(0xffb8b8b8)),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            child:
                                                                customtextformfield(
                                                              enabled:
                                                                  additionEdit,
                                                              controller:
                                                                  studyfirst,
                                                              verticalContentPadding:
                                                                  0,
                                                              hinttext:
                                                                  '1st Study In',
                                                              hintTextColor:
                                                                  Colors.black,
                                                              bottomLineColor:
                                                                  Color(
                                                                      0xffb8b8b8),
                                                              // newIcon: Container(
                                                              //   height: Get.height * 0.025,
                                                              //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                              // ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        secondname,
                                                                    hinttext:
                                                                        '2nd Name',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled: additionEdit,
                                                                    controller: seconddob,
                                                                    readOnly: true,
                                                                    callback: () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        seconddob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type: TextInputType.datetime,
                                                                    hinttext: '2nd Birth Date',
                                                                    hintTextColor: Colors.black,
                                                                    newIcon: Container(
                                                                        height: Get.height * 0.025,
                                                                        child: Image.asset(
                                                                          'assets/birthdate.png',
                                                                          color:
                                                                              appcolor.redColor,
                                                                        )),
                                                                    bottomLineColor: Color(0xffb8b8b8)),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            child:
                                                                customtextformfield(
                                                              enabled:
                                                                  additionEdit,
                                                              controller:
                                                                  secondstudyin,
                                                              verticalContentPadding:
                                                                  0,
                                                              hinttext:
                                                                  '2nd Study In',
                                                              hintTextColor:
                                                                  Colors.black,
                                                              bottomLineColor:
                                                                  Color(
                                                                      0xffb8b8b8),
                                                              // newIcon: Container(
                                                              //   height: Get.height * 0.025,
                                                              //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                              // ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled:
                                                                        additionEdit,
                                                                    controller:
                                                                        thrdname,
                                                                    hinttext:
                                                                        '3rd Name',
                                                                    hintTextColor:
                                                                        Colors
                                                                            .black,
                                                                    bottomLineColor:
                                                                        Color(
                                                                            0xffb8b8b8)),
                                                              ),
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.055,
                                                                width:
                                                                    Get.width *
                                                                        0.45,
                                                                child: customtextformfield(
                                                                    enabled: additionEdit,
                                                                    controller: thrddob,
                                                                    readOnly: true,
                                                                    callback: () async {
                                                                      if (additionEdit ==
                                                                          true) {
                                                                        thrddob.text =
                                                                            await profileController.showdatepicker(context);
                                                                      }
                                                                    },
                                                                    key_type: TextInputType.datetime,
                                                                    hinttext: '3rd Birth Date',
                                                                    hintTextColor: Colors.black,
                                                                    newIcon: Container(
                                                                        height: Get.height * 0.025,
                                                                        child: Image.asset(
                                                                          'assets/birthdate.png',
                                                                          color:
                                                                              appcolor.redColor,
                                                                        )),
                                                                    bottomLineColor: Color(0xffb8b8b8)),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: Get.height *
                                                                0.055,
                                                            child:
                                                                customtextformfield(
                                                              enabled:
                                                                  additionEdit,
                                                              controller:
                                                                  thrdstudy,
                                                              verticalContentPadding:
                                                                  0,
                                                              hinttext:
                                                                  '3rd Study In',
                                                              hintTextColor:
                                                                  Colors.black,
                                                              bottomLineColor:
                                                                  Color(
                                                                      0xffb8b8b8),
                                                              // newIcon: Container(
                                                              //   height: Get.height * 0.025,
                                                              //     child:Image.asset('assets/birthdate.png',color: appcolor.redColor,)
                                                              // ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container()
                                      ],
                                    )
                                  : SizedBox(
                                      height: 20,
                                    ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "${AppLocalizations.of(context)!.bloodGroup}:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          additionEdit == true
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  height: Get.height * 0.05,
                                  // width: Get.width * 0.3,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xffb8b8b8),
                                      ),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                  child: Center(
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration.collapsed(
                                        hintText:
                                            '${data['bloodgroup'] == null ? 'Blood Group' : data['bloodgroup']}',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          height: 2.5,
                                        ),
                                      ),
                                      //value: value,
                                      onChanged: (value) {
                                        bloodgroups = value;
                                        print(bloodgroups);
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          child: Text(
                                            'A+',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                            child: Text(
                                              'A-',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            value: 2),
                                        DropdownMenuItem(
                                          child: Text(
                                            'B+',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 3,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(
                                            'B-',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 4,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(
                                            'AB+',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 5,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(
                                            'AB-',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 6,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(
                                            'O+',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 7,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(
                                            'O-',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          value: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 0),
                                  height: Get.height * 0.055,
                                  child: customtextformfield(
                                    enabled: additionEdit,
                                    readOnly: true,
                                    verticalContentPadding: 0,
                                    hinttext:
                                        '${bloodgroup == null ? 'Blood Group' : bloodgroup}',
                                    hintTextColor: Colors.black,
                                    bottomLineColor: Color(0xffb8b8b8),
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: additionEdit,
                              controller: workExperience,
                              verticalContentPadding: 0,
                              hinttext:
                                  AppLocalizations.of(context)!.workExperience,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: additionEdit,
                              controller: reading,
                              verticalContentPadding: 0,
                              hinttext: AppLocalizations.of(context)!
                                  .languageKnownReading,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: additionEdit,
                              controller: writings,
                              verticalContentPadding: 0,
                              hinttext: AppLocalizations.of(context)!
                                  .languageKnownWriting,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: additionEdit,
                              controller: speaking,
                              verticalContentPadding: 0,
                              hinttext: AppLocalizations.of(context)!
                                  .languageKnownSpeaking,
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: customtextformfield(
                              enabled: additionEdit,
                              controller: cin,
                              verticalContentPadding: 0,
                              hinttext:
                                  '${AppLocalizations.of(context)!.dealer}/${AppLocalizations.of(context)!.partner}/${AppLocalizations.of(context)!.code}',
                              hintTextColor: Colors.black,
                              bottomLineColor: Color(0xffb8b8b8),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: blockButton(
                              callback: () {
                                if (additionEdit == true) {
                                  var value = {
                                    'nationality': Nationalityd == null
                                        ? nationality
                                        : Nationalityd == '1'
                                            ? 'india'
                                            : 'nepal',
                                    'marital_status': groupValue.value == null
                                        ? marriedstaus
                                        : groupValue.value == '1'
                                            ? 'married'
                                            : 'unmarried',
                                    'anniversary': anniversy.text.trim(),
                                    'children_info': radioVall == ''
                                        ? data['children_info']
                                        : radioVall,
                                    "oneChildName":
                                        firstname.text.trim().toString(),
                                    'oneChildStudy':
                                        studyfirst.text.trim().toString(),
                                    'oneChildDate':
                                        firstdob.text.trim().toString(),
                                    'secondChildName':
                                        secondname.text.trim().toString(),
                                    'secondChildDate':
                                        seconddob.text.trim().toString(),
                                    'secondChildStudy':
                                        secondstudyin.text.trim().toString(),
                                    'thirdChildName':
                                        thrdname.text.trim().toString(),
                                    'thirdChildDate':
                                        thrddob.text.trim().toString(),
                                    'thirdChildStudy':
                                        thrdstudy.text.trim().toString(),
                                    'bloodgroup': bloodgroups == 1
                                        ? 'A+'
                                        : bloodgroups == 2
                                            ? 'A-'
                                            : bloodgroups == 3
                                                ? 'B+'
                                                : bloodgroups == 4
                                                    ? 'B-'
                                                    : bloodgroups == 5
                                                        ? 'AB+'
                                                        : bloodgroups == 6
                                                            ? 'AB-'
                                                            : bloodgroups == 7
                                                                ? 'O+'
                                                                : bloodgroups ==
                                                                        8
                                                                    ? 'O-'
                                                                    : data['bloodgroup']
                                                                        .toString(),
                                    'experiance': workExperience.text.trim(),
                                    "reading": reading.text.trim().toString(),
                                    "writing": writings.text.trim().toString(),
                                    "speaking": speaking.text.trim().toString(),
                                    "partner": cin.text.trim().toString(),
                                  };
                                  setState(() {
                                    isLoading5 = true;
                                  });
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      isLoading5 = false;
                                    });
                                  });
                                  ProfileUpdate('aditionalinfo', value);
                                }
                                setState(() {
                                  additionEdit = true;
                                });
                              },
                              width: Get.width * 0.3,
                              widget: isLoading5 == false
                                  ? Text(
                                      '${additionEdit == true ? AppLocalizations.of(context)!.update : '${AppLocalizations.of(context)!.edit}'}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2),
                                    )
                                  : SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                              verticalPadding: 3,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
