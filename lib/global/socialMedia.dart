import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:kisaan_electric/global/appcolor.dart';

import 'package:kisaan_electric/global/customAppBar.dart';

import 'package:url_launcher/url_launcher.dart';

import '../Moddal/urlModal.dart';
import '../whatsaapIcon/WhatsaapIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class socialMedia extends StatefulWidget {
  const socialMedia({super.key});

  @override
  State<socialMedia> createState() => _socialMediaState();
}

class _socialMediaState extends State<socialMedia> {
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
          body: Banners.Items != null && Banners.Items.isNotEmpty
              ? ListView.builder(
                  itemCount: Banners.Items.length,
                  itemBuilder: (context, index) {
                    final url = Banners.Items[index];
                    return Column(
                      children: [
                        customAppBar(
                            '${AppLocalizations.of(context)!.socialMedia}', ''),
                        Container(
                          height: 1,
                          width: Get.width,
                          color: appcolor.borderColor,
                        ),
                        SizedBox(
                          height: Get.height * 0.1,
                        ),
                        Container(
                          child: Text(
                            AppLocalizations.of(context)!.followUsOn,
                            style: TextStyle(
                              fontSize: 20,
                              // decoration: TextDecoration.underline,
                              // decorationColor: appcolor.newRedColor,
                              height: 1,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 1,
                            width: Get.width * 0.6,
                            color: appcolor.newRedColor,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 10,
                          children: [
                            InkWell(
                              onTap: () {
                                var urls = url.facebook.toString();
                                _launchInBrowserView(urls);
                              },
                              child: Container(
                                child: Image(
                                  image: AssetImage(
                                    'assets/facebook.png',
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var urls = url.instagram.toString();
                                _launchInBrowserView(urls);
                              },
                              child: Container(
                                child: Image(
                                  image: AssetImage(
                                    'assets/insta.png',
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var urls = url.youtube.toString();
                                _launchInBrowserView(urls);
                              },
                              child: Container(
                                child: Image(
                                  image: AssetImage(
                                    'assets/youtube.png',
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var urls = url.linkedin.toString();
                                _launchInBrowserView(urls);
                              },
                              child: Container(
                                  child: Image.asset(
                                'assets/img_9.png',
                                height: 49.88,
                                width: 50,
                              )),
                            ),
                            InkWell(
                              onTap: () {
                                var urls = url.twitter.toString();
                                _launchInBrowserView(urls);
                              },
                              child: Container(
                                  child: Image.asset(
                                'assets/img_13.png',
                                height: 49.88,
                                width: 50,
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Text(
                            AppLocalizations.of(context)!.visitOurWebsite,
                            style: TextStyle(
                              fontSize: 22,
                              // decoration: TextDecoration.underline,
                              // decorationColor: appcolor.newRedColor,
                              height: 1,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 1,
                            width: Get.width * 0.6,
                            color: appcolor.newRedColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            var urls = 'https://haridayaindustries.com/';

                            _launchInBrowserView(urls);
                          },
                          child: Text(
                            'www.haridayaindustries.com ',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  Future<void> _launchInBrowserView(url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
