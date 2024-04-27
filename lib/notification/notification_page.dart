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

import '../server/apiDomain.dart';
import '../whatsaapIcon/WhatsaapIcon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class notifcation extends StatefulWidget {
  const notifcation({super.key});

  @override
  State<notifcation> createState() => _notifcation();
}

class _notifcation extends State<notifcation> {
  String text =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s,';
  String Date = '14 Oct at 5:40';
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
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title:
                customAppBar(AppLocalizations.of(context)!.notifications, ''),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
            future: api().GetData('notification', ''),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Image.asset(apiDomain().nodataimage.toString()),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      var date = data['created_at'].split('T');
                      var date1 = date[0];
                      var date2 = date1.split('-');
                      return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.grey[100],
                                  elevation: 5,
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: Get.width * 0.6,
                                            child: Text(
                                              '${data['data']['title']}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Text(
                                          '${date2[2]}-${date2[1]}-${date2[0]}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: appcolor.redColor),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: Get.width * 0.6,
                                            child: Text(
                                              '${data['data']['message'] == null ? '' : data['data']['message']}',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }
}
