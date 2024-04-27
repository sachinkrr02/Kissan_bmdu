import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/auth/ResetPassword/controller/reset_controller.dart';
import 'package:kisaan_electric/auth/login/controller/login_controller.dart';
import 'package:kisaan_electric/auth/login/view/login_view.dart';
import 'package:kisaan_electric/auth/register/controller/register_controller.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../global/customAppBar.dart';
import '../../../home/view/home_view.dart';
import '../../../server/apiDomain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class reset_password extends StatefulWidget {
  const reset_password({super.key});

  @override
  State<reset_password> createState() => _reset_passwordState();
}

class _reset_passwordState extends State<reset_password> {
  registerController controller = Get.put(registerController());
  TextEditingController mobile = TextEditingController();
  TextEditingController oldpass = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  resetController controllerpass = Get.put(resetController());
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

  bool isLoading = false;
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: customAppBar(
                '${AppLocalizations.of(context)!.changePassword}', ''),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.06,
                ),
                Container(
                  child: GradientText(
                    gradient: appcolor.gradient,
                    widget: Text(
                      AppLocalizations.of(context)!.changePassword,
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
                  height: Get.height * 0.055,
                  child: customtextformfield(
                      controller: mobile,
                      label: '*',
                      hinttext: AppLocalizations.of(context)!.mobileNumber,
                      suffixIcon: Icon(Icons.call),
                      newIcon: Icon(
                        Icons.call,
                        color: appcolor.redColor,
                      ),
                      key_type: TextInputType.phone,
                      maxLength: 10,
                      bottomLineColor: Color(0xffb8b8b8)),
                ),
                Container(
                  height: Get.height * 0.055,
                  child: customtextformfield(
                    controller: oldpass,
                    obsure: true,
                    label: '*',
                    bottomLineColor: Color(0xffb8b8b8),
                    hinttext: AppLocalizations.of(context)!.oldPassword,
                    suffixIcon: Icon(Icons.lock_open),
                    showPassword: controllerpass.showPassword.value,
                    callback: () {
                      controllerpass.showPassword.value =
                          !controllerpass.showPassword.value;
                      setState(() {});
                    },
                    newIcon: Icon(Icons.lock, color: appcolor.redColor),
                    key_type: TextInputType.visiblePassword,
                  ),
                ),
                Container(
                  height: Get.height * 0.055,
                  child: customtextformfield(
                      controller: newpass,
                      label: '*',
                      hinttext: AppLocalizations.of(context)!.newPassword,
                      suffixIcon: Icon(Icons.lock),
                      newIcon: Icon(Icons.lock, color: appcolor.redColor),
                      showPassword: controllerpass.showPassword1.value,
                      callback: () {
                        controllerpass.showPassword1.value =
                            !controllerpass.showPassword1.value;
                        setState(() {});
                      },
                      key_type: TextInputType.visiblePassword,
                      bottomLineColor: Color(0xffb8b8b8)),
                ),
                Container(
                  height: Get.height * 0.055,
                  child: customtextformfield(
                      controller: cpass,
                      label: '*',
                      hinttext: AppLocalizations.of(context)!.confirmPassword,
                      suffixIcon: Icon(Icons.lock_open),
                      showPassword: controllerpass.showPassword2.value,
                      callback: () {
                        controllerpass.showPassword2.value =
                            !controllerpass.showPassword2.value;
                        setState(() {});
                      },
                      newIcon: Icon(Icons.lock, color: appcolor.redColor),
                      key_type: TextInputType.visiblePassword,
                      bottomLineColor: Color(0xffb8b8b8)),
                ),
                Container(
                  height: Get.height * 0.055,
                  child: blockButton(
                      width: Get.width * 0.35,
                      callback: () {
                        var MobileNo = mobile.text.trim();
                        var OldPass = oldpass.text.trim();
                        var NewPass = newpass.text.trim();
                        var Cpass = cpass.text.trim();
                        if (MobileNo == '' &&
                            OldPass == '' &&
                            NewPass == '' &&
                            Cpass == '') {
                          alertBoxdialogBox(
                              context, 'Alert', 'Please Fill Fields');
                        } else if (NewPass != Cpass) {
                          alertBoxdialogBox(context, 'Alert',
                              'New Password Conform Password does not Match');
                        } else {
                          var value = {
                            "mobile_no": MobileNo,
                            "password": OldPass,
                            "new_password": NewPass,
                            "confirm_password": Cpass
                          };
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          ResetPassword(value);
                        }
                      },
                      widget: isLoading == false
                          ? Text(
                              AppLocalizations.of(context)!.submit,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            )
                          : SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              )),
                      verticalPadding: 3),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                  height: Get.height * 0.4,
                  child: Image(
                    image: AssetImage(
                      'assets/imgpsh_fullsize_anim (2) 1.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ),
    );
  }

  Future ResetPassword(Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response =
        await http.post(Uri.parse('${apiDomain().domain}changepassword'),
            body: jsonEncode(value),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        Get.offAll(Home_view());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data['message']}')));
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
