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
import 'package:kisaan_electric/global/terms&Condition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import '../Privacy&Policy/Privacy&policy.dart';
import '../auth/ResetPassword/view/reset_password.dart';
import '../global/legel.dart';
import '../profile/view/profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});
  @override
  State<HelpCenter> createState() => _HelpCenter();
}

class _HelpCenter extends State<HelpCenter> {
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
            //   image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
            ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: customAppBar(
                '${AppLocalizations.of(context)!.kisanHelpCenter}', ''),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 280,
                width: 296,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.hiHowCanWeHelpYou,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(profile_view());
                          },
                          child: Container(
                            height: 82,
                            width: 139,
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                                border: Border.all(color: appcolor.redColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child:
                                          Image.asset('assets/image 29.png')),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .accountSetting,
                                    style: TextStyle(fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(reset_password());
                          },
                          child: Container(
                            height: 82,
                            width: 139,
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                                border: Border.all(color: appcolor.redColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child:
                                          Image.asset('assets/image 30.png')),
                                  Text(
                                    AppLocalizations.of(context)!.loginPassword,
                                    style: TextStyle(fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(legel_view());
                          },
                          child: Container(
                            height: 82,
                            width: 139,
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                                border: Border.all(color: appcolor.redColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                          'assets/Rectangle 1.png')),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .privacySecurity,
                                    style: TextStyle(fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(termsandCondition());
                          },
                          child: Container(
                            height: 82,
                            width: 139,
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                                border: Border.all(color: appcolor.redColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child:
                                          Image.asset('assets/image 33.png')),
                                  Text(
                                    AppLocalizations.of(context)!.privacyPolicy,
                                    style: TextStyle(fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                          ),
                          Image.asset('assets/Vector (11).png'),
                          SizedBox(
                            width: 4,
                          ),
                          Text('${AppLocalizations.of(context)!.callUs}:'),
                          InkWell(
                              onTap: () {
                                _makePhoneCall('+91 8506001015');
                              },
                              child: Text(
                                '+91 8506001015',
                                style: TextStyle(color: appcolor.redColor),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                          ),
                          Image.asset('assets/Vector (12).png'),
                          SizedBox(
                            width: 4,
                          ),
                          Text('${AppLocalizations.of(context)!.emailUs}:'),
                          InkWell(
                              onTap: () {
                                var urls = 'care@haridayaindustries.com';
                                _makePhoneEmail(urls, 'tile', 'hello how');
                              },
                              child: Text(
                                'care@haridayaindustries.com',
                                style: TextStyle(color: appcolor.redColor),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makePhoneEmail(String email, title, message) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      //query: 'subject=$title&body=$message',
    );
    var Url = launchUri.toString();
    await launchUrl(Uri.parse(Url));
  }

  Future<void> _launchInBrowserView(url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
