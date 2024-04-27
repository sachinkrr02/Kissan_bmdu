import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/home/view/home_view.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../whatsaapIcon/WhatsaapIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class language extends StatefulWidget {
  const language({super.key});

  @override
  State<language> createState() => _languageState();
}

class _languageState extends State<language> {
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

  String groupValue = '1';
  var value = '1';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white

            // image: DecorationImage(
            //     image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
            ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customAppBar('${AppLocalizations.of(context)!.language}', ''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    gradient: appcolor.gradient,
                    widget: Text(
                      AppLocalizations.of(context)!.selectLanguage,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => appcolor.mixColor,
                          ),
                          value: '0',
                          groupValue: groupValue,
                          onChanged: (val) async {
                            groupValue = val.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("lang", "en");

                            Restart.restartApp();
                          }),
                      Text(
                        "English",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => appcolor.mixColor,
                          ),
                          value: '2',
                          groupValue: groupValue,
                          onChanged: (val) async {
                            groupValue = val.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("lang", "pt");

                            Restart.restartApp();
                          }),
                      Text(
                        "हिंदी",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => appcolor.mixColor,
                          ),
                          value: '3',
                          groupValue: groupValue,
                          onChanged: (val) async {
                            groupValue = val.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("lang", "pa");
                            Restart.restartApp();
                          }),
                      Text(
                        "ਪੰਜਾਬੀ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => appcolor.mixColor,
                          ),
                          value: '4',
                          groupValue: groupValue,
                          onChanged: (val) async {
                            groupValue = val.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("lang", "gu");
                            Restart.restartApp();
                          }),
                      Text(
                        "ગુજરાતી",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => appcolor.mixColor,
                          ),
                          value: '5',
                          groupValue: groupValue,
                          onChanged: (val) async {
                            groupValue = val.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("lang", "mr");
                            Restart.restartApp();
                            setState(() {});
                          }),
                      Text(
                        "मराठी",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => appcolor.mixColor,
                          ),
                          value: '7',
                          groupValue: groupValue,
                          onChanged: (val) async {
                            groupValue = val.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("lang", "ne");
                            Restart.restartApp();
                            setState(() {});
                          }),
                      Text(
                        "नेपाली",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 10,
              )
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }
}
