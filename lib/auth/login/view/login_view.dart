import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/auth/forgetPassword_view.dart';
import 'package:kisaan_electric/auth/login/controller/login_controller.dart';
import 'package:kisaan_electric/auth/register/view/register.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/home/view/home_view.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../server/apiDomain.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class login_view extends StatefulWidget {
  const login_view({super.key});
  @override
  State<login_view> createState() => _login_viewState();
}

class _login_viewState extends State<login_view> {
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  login_controller controller = Get.put(login_controller());
  var value = null;
  bool isLoading = false;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool _obscureText = true;
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
    getConnectivity();
  }

  Future termscondition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${apiDomain().domain}term_conditions'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future LoginApi(Object value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(Uri.parse('${apiDomain().domain}login'),
          body: jsonEncode(value),
          headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        if (data['success'] == true) {
          var Token = data['data']['token'];
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data['message']}')));
          Get.offAll(Home_view());
          prefs.setString('token', Token);
          setState(() {
            isLoading = false;
          });
        } else if (data['success'] == false) {
          alertBoxdialogBox(context, 'Alert', '${data['message']}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext contex) {
              return AlertDialog(
                title: Text(
                  'Welcome! ',
                  style: TextStyle(
                      color: appcolor.redColor, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Image.asset('assets/img_10.png',),
                    Text(
                        'It looks like you do not have an account yet. To get started '),
                  ],
                ),
                actions: [
                  Container(
                    height: Get.height * 0.055,
                    child: blockButton(
                      callback: () {
                        Get.to(register_view());
                      },
                      width: Get.width * 0.9,
                      widget: Text(
                        'Sign Up',
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
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String _selectedLanguage = 'english';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            //   image: DecorationImage(
            //       image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                ),
                // Text(
                //   _selectedLanguage == 'english'
                //       ? 'English Version'
                //       : 'Hindi Version',
                //   style: TextStyle(fontSize: 15),
                // ),
                Container(
                  child: GradientText(
                    gradient: appcolor.gradient,
                    widget: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: appcolor.redColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: Get.height * 0.08,
                  padding: EdgeInsets.only(top: 10),
                  child: customtextformfield(
                    controller: mobile,
                    bottomLineColor: Color(0xffb8b8b8),
                    hinttext: AppLocalizations.of(context)!.mobileNumber,
                    suffixIcon: Icon(Icons.call),
                    newIcon: Icon(
                      Icons.call,
                      color: appcolor.SufixIconColor,
                    ),
                    key_type: TextInputType.phone,
                    maxLength: 10,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: Get.height * 0.08,
                  padding: EdgeInsets.only(top: 10),
                  child: customtextformfield(
                      controller: password,
                      hinttext: AppLocalizations.of(context)!.password,
                      bottomLineColor: Color(0xffb8b8b8),
                      suffixIcon: Icon(Icons.lock),
                      newIcon: controller.showPassword.isTrue
                          ? Icon(
                              Icons.lock,
                              color: appcolor.SufixIconColor,
                            )
                          : Icon(
                              Icons.lock_open,
                              color: appcolor.SufixIconColor,
                            ),
                      showPassword: controller.showPassword.value,
                      key_type: TextInputType.visiblePassword,
                      callback: () {
                        controller.showPassword.value =
                            !controller.showPassword.value;
                        setState(() {});
                      }),
                ),
                Container(
                  height: Get.height * 0.055,
                  child: blockButton(
                    callback: () {
                      var Password = password.text.trim().toString();
                      var MobileNo = mobile.text.trim();
                      if (MobileNo == '' && Password == '') {
                        showDialog(
                            context: context,
                            builder: (BuildContext contex) {
                              return AlertDialog(
                                title: Text(
                                  'Alert',
                                  style: TextStyle(
                                      color: appcolor.redColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //Image.asset('assets/img_10.png',),
                                    Text('Please fill fields'),
                                  ],
                                ),
                                actions: [
                                  Container(
                                    height: Get.height * 0.060,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
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
                                  ),
                                ],
                              );
                            });
                      } else if (MobileNo.length < 10) {
                        alertBoxdialogBox(context, 'Alert',
                            'The Mobile Number Must be 10 Digits.');
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        if (isLoading == true) {
                          var value = {
                            "password": Password,
                            "mobile_no": MobileNo,
                          };
                          LoginApi(value);

                          // Future.delayed(Duration(seconds: 2),(){
                          //   setState(() {
                          //     isLoading = false;
                          //   });
                          // });
                        }
                      }
                      //  Get.to(Home_view());
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
                            AppLocalizations.of(context)!.login,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                          ),
                    verticalPadding: 3,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(forgotPassword_view());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      child: GradientText(
                        widget: Text(
                          '${AppLocalizations.of(context)!.forgotPassword}?',
                          style:
                              TextStyle(fontSize: 15, color: appcolor.redColor),
                        ),
                        gradient: appcolor.gradient,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: GradientText(
                        gradient: appcolor.gradient,
                        widget: Text(
                          '${AppLocalizations.of(context)!.noAccount}? ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(register_view());
                      },
                      child: Stack(
                        children: [
                          Container(
                            child: GradientText(
                              widget: Text(
                                AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: appcolor.redColor),
                              ),
                              gradient: appcolor.gradient,
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.038,
                ),
                Container(
                  height: Get.height * 0.35,
                  child: Image(
                    image: AssetImage(
                      'assets/login 1.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.helpLineNumber}:- ',
                      style: TextStyle(color: appcolor.redColor),
                    ),
                    InkWell(
                        onTap: () {
                          _makePhoneCall('+91 8506001015');
                        },
                        child: Text('+91 8506001015'))
                  ],
                ),
                InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: FutureBuilder(
                                future: termscondition(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('data not found'),
                                    );
                                  } else if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 0),
                                        child: Html(
                                          data: """${snapshot.data['data']}""",
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ).paddingSymmetric(
                                horizontal: 2,
                              ),
                              actions: [
                                Container(
                                  height: Get.height * 0.055,
                                  child: blockButton(
                                    callback: () {
                                      setState(() {});
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
                    },
                    child: Text(
                      AppLocalizations.of(context)!.termsAndConditions,
                      style: TextStyle(color: appcolor.redColor),
                    )),
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 15),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(300),
                  topLeft: Radius.circular(2)),
              child: Container(
                height: 130,
                width: 140,
                decoration: BoxDecoration(
                    color: appcolor.redColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(300),
                        topLeft: Radius.circular(2))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        width: Get.width * 0.3,
                        height: Get.height * 0.035,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: AppLocalizations.of(context)!.language,
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              height: 1,
                            ),
                          ),
                          value: value,
                          onChanged: (value) async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            switch (value) {
                              case 1:
                                pref.setString("lang", "en");
                                break;
                              case 2:
                                pref.setString("lang", "pt");
                                break;
                              case 3:
                                pref.setString("lang", "pa");
                                break;
                              case 4:
                                pref.setString("lang", "gu");
                                break;
                              case 5:
                                pref.setString("lang", "mr");
                                break;
                              case 6:
                                pref.setString("lang", "or");
                                break;
                              case 7:
                                pref.setString("lang", "ne");
                                break;
                            }
                            Restart.restartApp();
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                'English',
                                style: TextStyle(fontSize: 13),
                              ),
                              value: 1,
                            ),
                            DropdownMenuItem(
                                child: Text(
                                  'Hindi',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                value: 2),
                            DropdownMenuItem(
                                child: Text(
                                  'Punjabi',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                value: 3),
                            DropdownMenuItem(
                                child: Text(
                                  'Gujrati',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                value: 4),
                            DropdownMenuItem(
                                child: Text(
                                  'Marathi',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                value: 5),
                            DropdownMenuItem(
                                child: Text(
                                  'Odia',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                value: 6),
                            DropdownMenuItem(
                                child: Text(
                                  'Nepali',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                value: 7),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
