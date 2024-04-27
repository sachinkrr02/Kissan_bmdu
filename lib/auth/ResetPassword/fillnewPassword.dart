import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/auth/login/controller/login_controller.dart';
import 'package:kisaan_electric/auth/login/view/login_view.dart';
import 'package:kisaan_electric/auth/register/controller/register_controller.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _forgotPassword_viewState();
}

class _forgotPassword_viewState extends State<NewPassword> {
  registerController controller = Get.put(registerController());

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
      child: Stack(

          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.white
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
                            'Forgot Password',
                            style:
                            TextStyle(
                                color: appcolor.redColor,
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: Get.height * 0.055,
                        child: customtextformfield(
                          bottomLineColor: Color(0xffb8b8b8),
                          hinttext: 'Mobile Number',
                          suffixIcon: Icon(Icons.call),
                          newIcon: Icon(Icons.call,color: appcolor.SufixIconColor,),
                          key_type: TextInputType.phone,
                          maxLength: 10,
                        ),
                      ),
                      Container(
                        height: Get.height * 0.055,
                        child: customtextformfield(
                          label: '*',
                          bottomLineColor: Color(0xffb8b8b8),
                          hinttext: 'Enter OTP',
                          suffixIcon: Container(
                            child: Image(
                                image: AssetImage(
                                  'assets/otp 1.png',
                                )),
                          ),
                          newIcon: Container(
                            child: Image(
                                image: AssetImage(
                                    'assets/otp 1.png'
                                )),
                          ),
                          key_type: TextInputType.phone,
                          maxLength: 4,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: GradientText(
                              gradient: appcolor.gradient,
                              widget: Text(
                                'Send Otp?',
                                style: TextStyle(
                                    fontSize: 15,color: appcolor.redColor
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: GradientText(
                              gradient: appcolor.gradient,
                              widget: Text(
                                'Resend Otp?',
                                style: TextStyle(
                                    fontSize: 15,color: appcolor.redColor
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 10),
                      Container(
                        height: Get.height * 0.055,
                        child: blockButton(
                            width: Get.width * 0.35,
                            widget: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                            verticalPadding: 3),
                      ),
                      SizedBox(height: Get.height * 0.07),
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
                          topLeft: Radius.circular(2)
                      )
                  ),
                ),
              ],
            )
          ]
      ),
    );
  }
}
