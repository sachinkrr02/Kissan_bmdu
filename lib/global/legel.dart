import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/terms&Condition.dart';
import '../Privacy&Policy/Privacy&policy.dart';
import '../whatsaapIcon/WhatsaapIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class legel_view extends StatefulWidget {
  const legel_view({super.key});

  @override
  State<legel_view> createState() => _legel_viewState();
}

class _legel_viewState extends State<legel_view> {
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
            children: [
              customAppBar('${AppLocalizations.of(context)!.legal}', ''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              InkWell(
                onTap: () {
                  Get.to(termsandCondition());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 5,
                  ),
                  height: Get.height * 0.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.termsAndConditions,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ).paddingSymmetric(
                    horizontal: 10,
                  ),
                ),
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  Get.to(privacy_policy());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 5,
                  ),
                  height: Get.height * 0.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.privacyPolicy,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ).paddingSymmetric(
                    horizontal: 10,
                  ),
                ),
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.black,
              ),
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }
}
