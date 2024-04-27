import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/AssignUserDetail/assign.dart';
import 'package:kisaan_electric/History/History_view.dart';
import 'package:kisaan_electric/Orders/OrderPage.dart';
import 'package:kisaan_electric/OurCatalog/Our_Cataog.dart';
import 'package:kisaan_electric/QR/view/qr_scanner_view.dart';
import 'package:kisaan_electric/auth/login/view/login_view.dart';
import 'package:kisaan_electric/auth/ResetPassword/view/reset_password.dart';
import 'package:kisaan_electric/global/aboutUsView.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/global/language.dart';
import 'package:kisaan_electric/global/legel.dart';
import 'package:kisaan_electric/global/referandEarn.dart';
import 'package:kisaan_electric/global/socialMedia.dart';
import 'package:kisaan_electric/products/view/product_view.dart';
import 'package:kisaan_electric/profile/view/profile_view.dart';
import 'package:kisaan_electric/scheme/view/schemes_view.dart';
import 'package:kisaan_electric/wallet/view/wallet_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AlertDialogBox/alertBoxContent.dart';
import '../Feedback/Feedback & Complaints.dart';
import '../HelpPage/HelpCenter.dart';
import '../Offer/OfferPage.dart';
import '../ranking/ranking.dart';
import '../server/apiDomain.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget customDrawer(
  context,
) {
  return FutureBuilder(
    future: HomeData(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('data not found'),
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasData) {
        var data = snapshot.data;
        var dataa = data['register_at'].split('T');
        var date = dataa[0];
        var datechange = date.split('-');
        return Drawer(
          backgroundColor: appcolor.greyColor,
          width: Get.width * 0.75,
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(profile_view());
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                CircleAvatar(
                                  backgroundColor: appcolor.borderColor,
                                  radius: 35,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '${apiDomain().imageUrl + data['profile_pic']}'),
                                    backgroundColor: appcolor.greyColor,
                                    child: data['profile_pic'] == null
                                        ? Icon(
                                            Icons.person,
                                          )
                                        : null,
                                    radius: 39,
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: Get.height * 0.08),
                                  height: Get.height * 0.03,
                                  width: Get.width * 0.2,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: appcolor.borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: data['percentage'] <= 10
                                        ? appcolor.redColor
                                        : data['percentage'] <= 60
                                            ? Color(0xffECFF0C)
                                            : Colors.green,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${data['percentage']}%',
                                      style: TextStyle(
                                        // height: 0.,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '${data['name']}',
                                    style: TextStyle(
                                        height: 1.5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '+91 ${data['mobile_no']}',
                                    style: TextStyle(
                                      height: 0.3,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    ' ${datechange[2]}-${datechange[1]}-${datechange[0]}',
                                    style: TextStyle(
                                      height: 1.2,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    ' ${AppLocalizations.of(context)!.code}: ${data['Cin_no']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingOnly(left: 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data['profession'].toString() == 'partner'
                      ? Container(
                          height: Get.height * 0.8,
                          child: ListView(
                            children: [
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(qr_scanner_view(
                                    data: data,
                                  ));
                                },
                                title: AppLocalizations.of(context)!.scan,
                                image: Container(
                                    child: Image.asset(
                                  'assets/scan 1.png',
                                )
                                    // Image(
                                    //   image: AssetImage('assets/scan 1.png',),
                                    // ),
                                    ),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(schemes_view());
                                },
                                title: AppLocalizations.of(context)!.scheme,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (3).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(wallet_view());
                                },
                                title: AppLocalizations.of(context)!.myWallet,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/Vector (1).png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(profile_view());
                                },
                                title: AppLocalizations.of(context)!.myProfile,
                                image: Container(
                                    height: Get.height * 0.025,
                                    child: Image.asset(
                                      'assets/Vector.png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  data['user_status'] == 'Pending'
                                      ? alertBoxdialogBox(context, 'Alert',
                                          'Status: ${data['user_status']}')
                                      : Get.to(product_view());
                                },
                                title:
                                    AppLocalizations.of(context)!.ourProducts,
                                image: Container(
                                    height: Get.height * 0.025,
                                    child: Image.asset(
                                      'assets/secured icon.png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(historyView(
                                    condition: data,
                                  ));
                                },
                                title: AppLocalizations.of(context)!.history,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (5).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(ranking());
                                },
                                title: AppLocalizations.of(context)!.ranking,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/Vector (7).png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(socialMedia());
                                },
                                title:
                                    AppLocalizations.of(context)!.socialMedia,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/Vector (2).png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(referandearn());
                                },
                                title:
                                    AppLocalizations.of(context)!.referAndEarn,
                                image: Container(
                                    child: Image.asset(
                                  'assets/share.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {},
                                title: AppLocalizations.of(context)!.rateUs,
                                image: Container(
                                    child: Image.asset(
                                  'assets/star__.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(aboutUs());
                                },
                                title: AppLocalizations.of(context)!.aboutUs,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (7).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.to(Our_Catalog());
                                },
                                title: AppLocalizations.of(context)!.ourCatalog,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (8).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.to(HelpCenter());
                                },
                                title: AppLocalizations.of(context)!.help,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (6).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.to(Feedback_Complaints());
                                },
                                title: AppLocalizations.of(context)!
                                    .feedbackAndComplaints,
                                image: Container(
                                    child: Image.asset(
                                  'assets/support.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(legel_view());
                                },
                                title: AppLocalizations.of(context)!.legal,
                                image: GradientText(
                                  gradient: appcolor.gradient,
                                  widget: Container(
                                      child: Image.asset(
                                    'assets/external-link-alt.png',
                                  )),
                                ),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(language());
                                },
                                title: AppLocalizations.of(context)!.language,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (9).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(reset_password());
                                },
                                title: AppLocalizations.of(context)!
                                    .changePassword,
                                image: Container(
                                    child: Image.asset(
                                  'assets/change.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Are you sure?',
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                      content: Text(
                                        'Do you want to Log Out?',
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      appcolor.redColor,
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2)))),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      appcolor.redColor,
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2)))),
                                              onPressed: () async {
                                                await preferences
                                                    .remove('token');
                                                Get.offAll(login_view());
                                              },
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                title: AppLocalizations.of(context)!.logout,
                                image: GradientText(
                                    gradient: appcolor.gradient,
                                    widget: Image.asset(
                                      'assets/Vector (10).png',
                                    )),
                              ),
                              SizedBox(
                                height: Get.height * 0.11,
                              ),
                              Text(
                                '    App Version 1.0.0',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: Get.height * 0.8,
                          child: ListView(
                            children: [
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(qr_scanner_view(
                                    data: data,
                                  ));
                                },
                                title: AppLocalizations.of(context)!.scan,
                                image: Container(
                                    child: Image.asset(
                                  'assets/scan 1.png',
                                )
                                    // Image(
                                    //   image: AssetImage('assets/scan 1.png',),
                                    // ),
                                    ),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(schemes_view());
                                },
                                title: AppLocalizations.of(context)!.scheme,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (3).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(OfferPage());
                                },
                                title: AppLocalizations.of(context)!.offer,
                                image: Container(
                                    child: Image.asset(
                                  'assets/offers 2.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(wallet_view());
                                },
                                title: AppLocalizations.of(context)!.myWallet,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/Vector (1).png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(assign());
                                },
                                title: AppLocalizations.of(context)!.assign,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/img18.png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.offAll(profile_view());
                                },
                                title: AppLocalizations.of(context)!.myProfile,
                                image: Container(
                                    height: Get.height * 0.025,
                                    child: Image.asset(
                                      'assets/Vector.png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  data['user_status'] == 'Pending'
                                      ? alertBoxdialogBox(context, 'Alert',
                                          'Status: ${data['user_status']}')
                                      : Get.to(product_view());
                                },
                                title:
                                    AppLocalizations.of(context)!.ourProducts,
                                image: Container(
                                    height: Get.height * 0.025,
                                    child: Image.asset(
                                      'assets/secured icon.png',
                                    )),
                              ),
                              data['profession'].toString() == 'dealer'
                                  ? drawerWidget(
                                      callback: () {
                                        data['user_status'] == 'Pending'
                                            ? alertBoxdialogBox(
                                                context,
                                                'Alert',
                                                'Status: ${data['user_status']}')
                                            : Get.to(OrderPage());
                                      },
                                      title:
                                          AppLocalizations.of(context)!.orders,
                                      image: Container(
                                          height: Get.height * 0.025,
                                          child: Image.asset(
                                            'assets/Vector (4).png',
                                          )),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(historyView(
                                    condition: data,
                                  ));
                                },
                                title: AppLocalizations.of(context)!.history,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (5).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(ranking());
                                },
                                title: AppLocalizations.of(context)!.ranking,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/Vector (7).png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(socialMedia());
                                },
                                title:
                                    AppLocalizations.of(context)!.socialMedia,
                                image: Container(
                                    height: Get.height * 0.02,
                                    child: Image.asset(
                                      'assets/Vector (2).png',
                                    )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(referandearn());
                                },
                                title:
                                    AppLocalizations.of(context)!.referAndEarn,
                                image: Container(
                                    child: Image.asset(
                                  'assets/share.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  _launchPlayStore();
                                },
                                title: AppLocalizations.of(context)!.rateUs,
                                image: Container(
                                    child: Image.asset(
                                  'assets/star__.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(aboutUs());
                                },
                                title: AppLocalizations.of(context)!.aboutUs,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (7).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.to(Our_Catalog());
                                },
                                title: AppLocalizations.of(context)!.ourCatalog,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (8).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.to(HelpCenter());
                                },
                                title: AppLocalizations.of(context)!.help,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (6).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.to(Feedback_Complaints());
                                },
                                title: AppLocalizations.of(context)!
                                    .feedbackAndComplaints,
                                image: Container(
                                    child: Image.asset(
                                  'assets/support.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(legel_view());
                                },
                                title: AppLocalizations.of(context)!.legal,
                                image: GradientText(
                                  gradient: appcolor.gradient,
                                  widget: Container(
                                      child: Image.asset(
                                    'assets/external-link-alt.png',
                                  )),
                                ),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(language());
                                },
                                title: AppLocalizations.of(context)!.language,
                                image: Container(
                                    child: Image.asset(
                                  'assets/Vector (9).png',
                                )),
                              ),
                              drawerWidget(
                                callback: () {
                                  Get.back();
                                  Get.to(reset_password());
                                },
                                title: AppLocalizations.of(context)!
                                    .changePassword,
                                image: Container(
                                    child: Image.asset(
                                  'assets/change.png',
                                )),
                              ),
                              drawerWidget(
                                callback: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Are you sure?',
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                      content: Text(
                                        'Do you want to Log Out?',
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      appcolor.redColor,
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2)))),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      appcolor.redColor,
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2)))),
                                              onPressed: () async {
                                                await preferences
                                                    .remove('token');
                                                Get.offAll(login_view());
                                              },
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                title: AppLocalizations.of(context)!.logout,
                                image: GradientText(
                                    gradient: appcolor.gradient,
                                    widget: Image.asset(
                                      'assets/Vector (10).png',
                                    )),
                              ),
                              Text(
                                '    ${AppLocalizations.of(context)!.appVersion} 1.0.0',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ).paddingSymmetric(
                horizontal: 10,
              ),
            ),
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

Widget drawerWidget({
  Icon? icon,
  Widget? image,
  String? title,
  Function()? callback,
}) {
  return InkWell(
    onTap: callback,
    child: Container(
      padding: EdgeInsets.only(left: 5, bottom: 2),
      width: Get.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: Get.height * 0.05,
            child: icon == null
                ? CircleAvatar(
                    radius: 17,
                    backgroundColor: appcolor.borderColor,
                    child: CircleAvatar(
                        radius: 16,
                        backgroundColor: appcolor.greyColor,
                        child: image))
                : CircleAvatar(
                    child: icon,
                  ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            '$title',
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    ),
  );
}

void _launchPlayStore() async {
  const url =
      'https://play.google.com/store/apps/details?id=com.BMDU.kisaan_electric';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future HomeData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  final response = await http.post(Uri.parse('${apiDomain().domain}mainpage'),
      headers: ({
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data;
  } else if (response.statusCode == 404) {
    Get.offAll(apiDomain().login);
  }
}
