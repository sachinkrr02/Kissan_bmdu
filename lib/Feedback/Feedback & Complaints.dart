import 'dart:async';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import '../AlertDialogBox/alertBoxContent.dart';
import '../home/view/home_view.dart';
import '../server/apiDomain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Feedback_Complaints extends StatefulWidget {
  const Feedback_Complaints({super.key});
  @override
  State<Feedback_Complaints> createState() => _Feedback_Complaints();
}

class _Feedback_Complaints extends State<Feedback_Complaints> {
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  RxString groupValue = 'feedback'.obs;
  RxString profilegroupvalue = 'complaints'.obs;
  File? SelectedImage;
  bool isLoading = false;
  bool showSpinner = false;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> sendImageToServer(
    String subject,
    message,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var choose = profilegroupvalue.value.toString();
    print(choose);
    var uri = Uri.parse(
        '${apiDomain().domain}feedback'); // Replace with your server's endpoint
    var request = http.MultipartRequest("POST", uri)
      ..files
          .add(await http.MultipartFile.fromPath('image', SelectedImage!.path));
    request.headers['Authorization'] = 'Bearer ' + '$token';
    request.fields['subject'] = '$subject';
    request.fields['message'] = '$message';
    request.fields['category'] = '$choose';
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      var rest = jsonDecode(res.body);
      print(res.body);
      if (rest['status'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${rest['message']}')));
        Get.offAll(Home_view());
      } else if (rest['status'] == false) {
        alertBoxdialogBox(context, 'Alert', '${rest['message']}');
        //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data['message']}')));
      } else {
        alertBoxdialogBox(context, 'Alert', 'Failed');
      }
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white
            // image: DecorationImage(
            //   image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
            ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: customAppBar(
                '${AppLocalizations.of(context)!.feedbackAndComplaints}', ''),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: Get.height * 0.65,
                  width: 311,
                  decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Center(
                          child: Container(
                            height: Get.height * 0.04,
                            child: Row(
                              children: [
                                Radio(
                                  value: 'feedback',
                                  groupValue: profilegroupvalue.value,
                                  onChanged: (val) {
                                    profilegroupvalue.value = val.toString();
                                  },
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) => appcolor.mixColor,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    groupValue.value = 'feedback';
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.feedback,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Radio(
                                  value: 'complaints',
                                  groupValue: profilegroupvalue.value,
                                  onChanged: (val) {
                                    profilegroupvalue.value = val.toString();
                                  },
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) => appcolor.mixColor,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    groupValue.value = 'complaints';
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.complaints,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            height: 38,
                            width: 284,
                            child: TextField(
                              controller: subject,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)!.subject,
                                  hintStyle: TextStyle(color: Colors.black),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: appcolor.redColor)),
                                  border: UnderlineInputBorder()),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            height: Get.height * 0.3,
                            width: 284,
                            child: TextField(
                              controller: message,
                              maxLines: 15,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  hintText:
                                      '${AppLocalizations.of(context)!.message}....',
                                  hintStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: appcolor.redColor)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  border: UnderlineInputBorder()),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.uploadImage,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 80,
                                      color: appcolor.redColor,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    imagePickerCamera();
                                                  },
                                                  icon: Icon(
                                                    Icons.camera,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Camera',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                                    imagePicker();
                                                  },
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.file,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'File',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                              },
                              child: Card(
                                child: Container(
                                  height: 80,
                                  width: 144,
                                  child: SelectedImage == null
                                      ? Image.asset('assets/Vector1.png')
                                      : Image.file(
                                          SelectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: Get.height * 0.055,
                          child: blockButton(
                              callback: () {
                                var Subject = subject.text.trim().toString();
                                var Message = message.text.trim().toString();
                                if (Subject == null && Message == null) {
                                  alertBoxdialogBox(
                                      context, 'Alert', 'Please fill field');
                                } else if (SelectedImage == null) {
                                  alertBoxdialogBox(
                                      context, 'Alert', 'Please Select Image');
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Future.delayed(Duration(seconds: 4), () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                  sendImageToServer(
                                    Subject,
                                    Message,
                                  );
                                }
                              },
                              width: Get.width * 0.3,
                              widget: isLoading == false
                                  ? Text(
                                      AppLocalizations.of(context)!.submit,
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
                                      ))),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  var image64 = '';
  Future imagePicker() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/fedback&complaint.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);

    setState(() {
      SelectedImage = File(result!.path);
      image64 = base64Encode(SelectedImage!.readAsBytesSync());
      //   Navigator.of(context).pop();
    });
  }

  Future imagePickerCamera() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/fedback&complaint.jpg';
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    var result = await FlutterImageCompress.compressAndGetFile(
        returnedImage.path, targetPath,
        quality: 50);
    setState(() {
      SelectedImage = File(result!.path);
      image64 = base64Encode(SelectedImage!.readAsBytesSync());
      Navigator.of(context).pop();
    });
  }
}
