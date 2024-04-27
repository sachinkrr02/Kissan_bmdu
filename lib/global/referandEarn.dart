import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/global/legel.dart';
import 'package:kisaan_electric/profile/view/profile_view.dart';
import 'package:share_plus/share_plus.dart';
import '../whatsaapIcon/WhatsaapIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class referandearn extends StatefulWidget {
  const referandearn({super.key});

  @override
  State<referandearn> createState() => _referandearnState();
}

class _referandearnState extends State<referandearn> {
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

  String copy = 'ELECTRICKISSANNEW1';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white

            // image: DecorationImage(
            //   image: AssetImage('assets/rectangle.png'),
            //   fit: BoxFit.fill,
            // ),
            ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              customAppBar('${AppLocalizations.of(context)!.referAndEarn}', ''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          GradientText(
                            gradient: appcolor.gradient,
                            widget: Text(
                              'Mohit Kumar ',
                              style: TextStyle(fontSize: 16, height: 1),
                            ),
                          ),
                          Text(
                            '+91-987653429',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(profile_view());
                        },
                        child: Text(
                          AppLocalizations.of(context)!.viewDetails,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GradientText(
                    gradient: appcolor.gradient,
                    widget: Text(
                      AppLocalizations.of(context)!.referAndEarn,
                      style: TextStyle(fontSize: 16, height: 1),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.referralReward,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    color: appcolor.newRedColor,
                    radius: Radius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: appcolor.greyColor,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            copy,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1,
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                              right: 5,
                            ),
                            width: 1,
                            color: Colors.black,
                            height: Get.height * 0.025,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                                height: Get.height * 0.022,
                                child: Image.asset(
                                  'assets/Vector (1).png',
                                  color: appcolor.redColor,
                                )),
                          ),
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: copy));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(copy)));
                            },
                            child: Text(
                              ' ${AppLocalizations.of(context)!.copy}',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1,
                                color: Colors.blue[300],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Share.share('$copy', subject: 'Kissann Electronic');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: appcolor.newRedColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: Get.height * 0.022,
                                child: Text(
                                  AppLocalizations.of(context)!.shareOn,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: Image(
                                    image: AssetImage('assets/whatsa.png')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: Get.height * 0.055,
                        child: blockButton(
                          callback: () {
                            Share.share('$copy', subject: 'Kissann Electronic');
                          },
                          width: Get.width * 0.3,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: Get.height * 0.022,
                                child: Text(
                                  AppLocalizations.of(context)!.share,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: Image(
                                    image: AssetImage(
                                  'assets/share_white.png',
                                )),
                              ),
                            ],
                          ),
                          verticalPadding: 3,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(
                    vertical: 10,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientText(
                            gradient: appcolor.gradient,
                            widget: Text(
                              AppLocalizations.of(context)!.callUs,
                              style: TextStyle(fontSize: 16, height: 1),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.forAnyQueries,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: Get.height * 0.055,
                        child: blockButton(
                          callback: () async {},
                          width: Get.width * 0.3,
                          widget: Text(
                            AppLocalizations.of(context)!.callUs,
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
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.mailUsAt} ',
                        style: TextStyle(fontSize: 16, height: 1),
                      ),
                      Text(
                        'info@kissanelectric.com',
                        style: TextStyle(
                            fontSize: 14, height: 1, color: Colors.blue[400]),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(legel_view());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: appcolor.newRedColor,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: Get.height * 0.022,
                            child: Text(
                              AppLocalizations.of(context)!.legal,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 5,
                            ),
                            child: Image(
                                image: AssetImage('assets/iosforward.png')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 15),
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }
}
