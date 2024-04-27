import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/auth/login/controller/login_controller.dart';
import 'package:kisaan_electric/auth/login/view/login_view.dart';
import 'package:kisaan_electric/auth/register/controller/register_controller.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../server/apiDomain.dart';

class forgotPassword_view extends StatefulWidget {
  const forgotPassword_view({super.key});

  @override
  State<forgotPassword_view> createState() => _forgotPassword_viewState();
}

class _forgotPassword_viewState extends State<forgotPassword_view> {
  TextEditingController mobile = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController ConformPassword = TextEditingController();
  registerController controller = Get.put(registerController());
  var Otps;
  var conditon;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: Colors.white
              //   image: DecorationImage(
              //       image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
              ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.13,
                  ),
                  Container(
                    child: GradientText(
                      gradient: appcolor.gradient,
                      widget: Text(
                        AppLocalizations.of(context)!.forgetpassword,
                        style: TextStyle(
                            color: appcolor.redColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: Get.height * 0.080,
                    child: customtextformfield(
                      controller: mobile,
                      bottomLineColor: Color(0xffb8b8b8),
                      hinttext: AppLocalizations.of(context)!.phoneNumber,
                      suffixIcon: Icon(Icons.call),
                      newIcon: Icon(
                        Icons.call,
                        color: appcolor.SufixIconColor,
                      ),
                      key_type: TextInputType.phone,
                      maxLength: 10,
                    ),
                  ),
                  // Container(
                  //   height: Get.height * 0.080,
                  //   child: customtextformfield(
                  //     controller: otp,
                  //     label: '*',
                  //     bottomLineColor: Color(0xffb8b8b8),
                  //     hinttext: 'Enter OTP',
                  //     suffixIcon: Container(
                  //       child: Image(
                  //           image: AssetImage(
                  //         'assets/otp 1.png',
                  //       )),
                  //     ),
                  //     newIcon: Container(
                  //       child: Image(image: AssetImage('assets/otp 1.png')),
                  //     ),
                  //     key_type: TextInputType.phone,
                  //     maxLength: 6,
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         Otps = random(100000, 999999);
                  //         var MobileNo = mobile.text.toString();
                  //         if (MobileNo == '') {
                  //           alertBoxdialogBox(
                  //               context, 'Alert', 'Please Enter Mobile Number');
                  //         } else {
                  //           otps(MobileNo, Otps);
                  //         }
                  //       },
                  //       child: GradientText(
                  //         gradient: appcolor.gradient,
                  //         widget: Padding(
                  //           padding: const EdgeInsets.only(top: 3),
                  //           child: Text(
                  //             'Send Otp?',
                  //             style: TextStyle(
                  //                 fontSize: 15, color: appcolor.redColor),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         if (Otps.toString() == otp.text.toString()) {
                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //               content: Text('OTP match suceessful')));
                  //           setState(() {
                  //             conditon = 'suc';
                  //           });
                  //         } else {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //               SnackBar(content: Text('OTP did not match ')));
                  //         }
                  //       },
                  //       child: GradientText(
                  //         gradient: appcolor.gradient,
                  //         widget: Padding(
                  //           padding: const EdgeInsets.only(top: 3),
                  //           child: Text(
                  //             'Verify Otp?',
                  //             style: TextStyle(
                  //                 fontSize: 15, color: appcolor.redColor),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ).paddingSymmetric(horizontal: 10),
                  // conditon == 'suc'
                  //     ? Column(
                  //         children: [
                  //           Container(
                  //             height: Get.height * 0.055,
                  //             child: customtextformfield(
                  //               controller: newPassword,
                  //               label: '*',
                  //               bottomLineColor: Color(0xffb8b8b8),
                  //               hinttext: 'New Password',
                  //               suffixIcon: Icon(Icons.lock_open),
                  //               showPassword: controller.showPassword.value,
                  //               // callback: () {
                  //               //   controller.showPassword.value =
                  //               //   !controller.showPassword.value;
                  //               //   setState(() {});
                  //               // },
                  //               newIcon: Icon(
                  //                 Icons.lock,
                  //                 color: Colors.red,
                  //               ),
                  //               key_type: TextInputType.visiblePassword,
                  //             ),
                  //           ),
                  //           Container(
                  //             height: Get.height * 0.055,
                  //             child: customtextformfield(
                  //               controller: ConformPassword,
                  //               label: '*',
                  //               bottomLineColor: Color(0xffb8b8b8),
                  //               hinttext: 'Conform Password',
                  //               suffixIcon: Icon(Icons.lock_open),
                  //               showPassword: controller.showPassword.value,
                  //               // callback: () {
                  //               //   controller.showPassword.value =
                  //               //   !controller.showPassword.value;
                  //               //   setState(() {});
                  //               // },
                  //               newIcon: Icon(
                  //                 Icons.lock,
                  //                 color: Colors.red,
                  //               ),
                  //               key_type: TextInputType.visiblePassword,
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(
                  //         height: 0,
                  //         width: 0,
                  //       ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: Get.height * 0.055,
                      child: blockButton(
                          callback: () {
                            // var moileno = mobile.text.toString();
                            // var password = newPassword.text.toString();
                            // var conform = ConformPassword.text.toString();
                            // if(password=='' && conform == ''){
                            //
                            // }else if(password.toString() != conform.toString()){
                            //   return alertBoxdialogBox(context, 'Alert', 'Please enter same password');
                            // }else{
                            //   var value = {
                            //     "mobile_no":moileno,
                            //     "password":conform
                            //   };
                            //   forget(value);
                            // }
                            Otps = random(100000, 999999);
                            var MobileNo = mobile.text.toString();
                            if (MobileNo == '') {
                              alertBoxdialogBox(context, 'Alert',
                                  'Please Enter Mobile Number');
                            } else {
                              otps(MobileNo, Otps);
                            }
                          },
                          width: Get.width * 0.35,
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.submit,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                          verticalPadding: 3),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Container(
                    height: Get.height * 0.4,
                    child: Image(
                      image: AssetImage(
                        'assets/image-png 1 (1).png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 130,
              width: 140,
              decoration: BoxDecoration(
                  color: appcolor.redColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(300),
                      topLeft: Radius.circular(2))),
            ),
          ],
        )
      ]),
    );
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future otps(
    String phonNumber,
    OTP,
  ) async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
            'http://nimbusit.biz/api/SmsApi/SendSingleApi?UserID=HariDayabiz&Password=blzx1639BL&SenderID=KSNHDI&Phno=$phonNumber&Msg=Hi, Your OTP for Kisaan Parivar App is $OTP. This OTP is valid for 5 minutes.&EntityID=1701170324305196194&TemplateID=1707170332162391890'),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Status'] == "OK") {
        Get.to(OTPScreen(
          otp: OTP,
          mobileno: phonNumber,
        ));
        // alertBoxdialogBox(context, 'OTP', 'OTP send Successful');
      }
    }
  }
}

class OTPScreen extends StatefulWidget {
  final mobileno;
  final int otp;
  const OTPScreen({super.key, required this.otp, required this.mobileno});

  @override
  State<OTPScreen> createState() => _OTPScreenState(mobileno);
}

class _OTPScreenState extends State<OTPScreen> {
  final mobileno;
  var match;

  _OTPScreenState(this.mobileno);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Center(
                child: Image.asset(
              'assets/kissanlogo.png',
              fit: BoxFit.contain,
              height: Get.height * 0.35,
              width: Get.width * 0.7,
            )
                //Text('Welcome \nBack',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: Get.height * 0.31,
              width: Get.width,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                // margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(11),
                        topRight: Radius.circular(11))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'OTP VERIFICATION'.tr,
                        style: TextStyle(
                            color: Color.fromRGBO(53, 53, 52, 1),
                            fontSize: 24,
                            fontFamily: 'Nunito-Regular.ttf',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Verify Your Mobile Number'.tr,
                        style: TextStyle(
                            color: Color.fromRGBO(53, 53, 52, 1),
                            fontSize: 16,
                            fontFamily: 'Nunito-Regular.ttf',
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Verify your mobile number'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'nunito'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Pinput(
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        length: 6,
                        showCursor: true,
                        onCompleted: (pin) {
                          setState(() {
                            match = pin;
                            // print('sdf$Match');
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RichText(
                        maxLines: 2,
                        text: TextSpan(
                          text: 'Dont receive OTP '.tr,
                          style: TextStyle(color: Colors.black),
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Resend',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            blockButton(
                color: appcolor.redColor,
                callback: () {
                  if (match.toString() == widget.otp.toString()) {
                    Get.to(ChagePassword(
                      mobileno: mobileno,
                    ));
                  }
                },
                width: Get.width * 0.9,
                widget: Text(
                  'Verify OTP'.tr,
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class ChagePassword extends StatefulWidget {
  final mobileno;
  const ChagePassword({super.key, this.mobileno});

  @override
  State<ChagePassword> createState() => _ChagePasswordState();
}

class _ChagePasswordState extends State<ChagePassword> {
  registerController controller = Get.put(registerController());
  TextEditingController mobile = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController ConformPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
                child: Image.asset(
              'assets/kissanlogo.png',
              fit: BoxFit.contain,
              height: Get.height * 0.35,
              width: Get.width * 0.7,
            )
                //Text('Welcome \nBack',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                ),
            Container(
              height: Get.height * 0.055,
              child: customtextformfield(
                controller: newPassword,
                label: '*',
                bottomLineColor: Color(0xffb8b8b8),
                hinttext: 'New Password',
                suffixIcon: Icon(Icons.lock_open),
                showPassword: controller.showPassword.value,
                // callback: () {
                //   controller.showPassword.value =
                //   !controller.showPassword.value;
                //   setState(() {});
                // },
                newIcon: Icon(
                  Icons.lock,
                  color: Colors.red,
                ),
                key_type: TextInputType.visiblePassword,
              ),
            ),
            Container(
              height: Get.height * 0.055,
              child: customtextformfield(
                controller: ConformPassword,
                label: '*',
                bottomLineColor: Color(0xffb8b8b8),
                hinttext: 'Conform Password',
                suffixIcon: Icon(Icons.lock_open),
                showPassword: controller.showPassword.value,
                // callback: () {
                //   controller.showPassword.value =
                //   !controller.showPassword.value;
                //   setState(() {});
                // },
                newIcon: Icon(
                  Icons.lock,
                  color: Colors.red,
                ),
                key_type: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            blockButton(
                color: appcolor.redColor,
                callback: () {
                  var moileno = widget.mobileno;
                  var password = newPassword.text.toString();
                  var conform = ConformPassword.text.toString();
                  if (password == '' && conform == '') {
                  } else if (password.toString() != conform.toString()) {
                    return alertBoxdialogBox(
                        context, 'Alert', 'Please enter same password');
                  } else {
                    var value = {
                      "mobile_no": widget.mobileno,
                      "password": conform
                    };
                    forget(value);
                  }
                },
                width: Get.width * 0.9,
                widget: Text(
                  'Submit'.tr,
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future forget(Object value) async {
    print(value);
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse('${apiDomain().domain}forgetPassword'),
        body: jsonEncode(value),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        Get.offAll(login_view());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data['message']}')));
        // prefs.setString('token', Token);
      } else if (data['status'] == false) {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
    }
  }
}
