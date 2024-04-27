import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/History/History_view.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/notification/notification_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../home/view/home_view.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class qr_scanner_view extends StatefulWidget {
  final data;
  const qr_scanner_view({super.key, this.data});

  @override
  State<qr_scanner_view> createState() => _qr_scanner_viewState(data);
}

class _qr_scanner_viewState extends State<qr_scanner_view> {
  var qrcodedata = '';
  TextEditingController qrcodetext = TextEditingController();
  bool isLoading = false;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final data;
  _qr_scanner_viewState(this.data);
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

  Future qrscanner() async {
    var camerstatus = await Permission.camera.status;
    if (camerstatus.isGranted) {
      String? qrdata = await scanner.scan();
      if (qrdata != null) {
        setState(() {
          qrcodedata = qrdata.toString();
          // qrcodetext.text = qrcodedata;

          var value = {"qrcode": qrcodedata};
          setState(() {
            isLoading = true;
          });
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              isLoading = false;
            });
          });
          qrCodescan(value);
        });
      }

      //print(qrdata);
    } else {
      var isgrant = await Permission.camera.request();
      if (isgrant.isGranted) {
        String? qrdata = await scanner.scan();
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, qrscanner);
        return true;
      },
      child: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WillPopScope(
              onWillPop: () async {
                Get.offAll(Home_view());
                return false;
              },
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Container(
                    width: Get.width * 0.4,
                    child: Image(
                      image: AssetImage(
                        'assets/plain logo 1.png',
                      ),
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        _makePhoneCall('+91 8506001015');
                        //Scaffold.of(context).openDrawer();
                      },
                      child: GradientText(
                        gradient: appcolor.gradient,
                        widget: Icon(
                          Icons.call,
                          color: appcolor.redColor,
                        ),
                      ),
                    ),
                    GradientText(
                        gradient: appcolor.gradient,
                        widget: IconButton(
                          onPressed: () {
                            Get.to(notifcation());
                          },
                          icon: Icon(
                            Icons.notifications,
                            color: appcolor.redColor,
                          ),
                        )),
                  ],
                  leading: GradientText(
                    gradient: appcolor.gradient,
                    widget: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: appcolor.redColor,
                        size: 25,
                      ),
                      onPressed: () {
                        Get.offAll(Home_view());
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: GradientText(
                          gradient: appcolor.gradient,
                          widget: Text(
                            AppLocalizations.of(context)!.scanYourCode,
                            style: TextStyle(
                                fontSize: 20, color: appcolor.redColor),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          qrscanner();
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appcolor.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: appcolor.greyColor,
                          ),
                          child: Image(
                              image: AssetImage(
                                  'assets/QR_code_for_mobile_English_Wikipedia 1.png')),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.holdYourPhone,
                        style: TextStyle(
                          fontSize: 15,
                          height: 0.9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: Get.height * 0.055,
                        child: customtextformfield(
                          controller: qrcodetext,
                          bottomLineColor: Color(0xffb8b8b8),
                          hinttext:
                              AppLocalizations.of(context)!.enterYourCouponCode,
                          key_type: TextInputType.visiblePassword,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: Get.height * 0.055,
                            child: blockButton(
                              callback: () {
                                var qrtext = qrcodetext.text.trim().toString();
                                setState(() {
                                  isLoading = true;
                                });
                                Future.delayed(Duration(seconds: 2), () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                                var value = {'qrcode': qrtext};
                                qrCodescan(value);
                              },
                              width: Get.width * 0.3,
                              widget: isLoading
                                  ? SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                  : Text(
                                      AppLocalizations.of(context)!.submit,
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.clickBelowToViewHistory,
                        style: TextStyle(
                          color: appcolor.redColor,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(historyView(
                              condition: data,
                            ));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.viewHistory,
                            style: TextStyle(
                              fontSize: 14,
                              color: appcolor.redColor,
                              decoration: TextDecoration.underline,
                            ),
                          ))
                    ],
                  ).paddingSymmetric(horizontal: 15, vertical: 15),
                ),
                floatingActionButton: floatingActionButon(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future qrCodescan(Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response =
        await http.post(Uri.parse('${apiDomain().domain}scan-qr-code'),
            body: jsonEncode(value),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data['message']}')));
        showDialog(
            context: context,
            builder: (BuildContext contex) {
              return AlertDialog(
                title: Text(
                  'Congratulations',
                  style: TextStyle(
                      color: appcolor.redColor, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/img_10.png',
                    ),
                    Text('You have earn ${data['rewards']['points']} Points'),
                  ],
                ),
                actions: [
                  Container(
                    height: Get.height * 0.055,
                    child: blockButton(
                      callback: () {
                        Get.back();
                      },
                      width: Get.width * 0.9,
                      widget: Text(
                        'Ok',
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
              );
            });
      } else if (data['status'] == false) {
        showDialog(
            context: context,
            builder: (BuildContext contex) {
              return AlertDialog(
                title: Text(
                  'Oops!',
                  style: TextStyle(
                      color: appcolor.redColor, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/img_12.png',
                    ),
                    Text('${data['message']}'),
                  ],
                ),
                actions: [
                  Container(
                    height: Get.height * 0.055,
                    child: blockButton(
                      callback: () {
                        Get.back();
                      },
                      width: Get.width,
                      widget: Text(
                        'Ok',
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
              );
            });
        //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data['message']}')));
      } else {}
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
