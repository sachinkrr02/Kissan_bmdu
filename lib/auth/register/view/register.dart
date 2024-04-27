import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/auth/login/view/login_view.dart';
import 'package:kisaan_electric/auth/register/controller/register_controller.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/home/view/home_view.dart';
import 'package:http/http.dart' as http;
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../AlertDialogBox/alertBoxContent.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class register_view extends StatefulWidget {
  const register_view({super.key});

  @override
  State<register_view> createState() => _register_viewState();
}

class _register_viewState extends State<register_view> {
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController bussinessName = TextEditingController();
  TextEditingController dealerPartnerCin = TextEditingController();
  TextEditingController referralCode = TextEditingController(text: "KISSAN");
  bool isSelected = false;
  registerController controller = Get.put(registerController());
  var value = null;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  var Matchs;

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

  var otps;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return SingleChildScrollView(
      child: SafeArea(
        child: Stack(children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(color: Colors.white
                // image: DecorationImage(
                //     image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
                ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.058,
                    ),
                    Container(
                      child: GradientText(
                        gradient: appcolor.gradient,
                        widget: Text(
                          AppLocalizations.of(context)!.signUp,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.note}: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: appcolor.redColor),
                        ),
                        Text(AppLocalizations.of(context)!
                            .kindlyfilldetailscarefully),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        // Text("Note: ",style: TextStyle(fontWeight: FontWeight.bold,color: appcolor.redColor),),
                        Text(AppLocalizations.of(context)!
                            .retailercansignupasadealer),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: Get.height * 0.055,
                      child: customtextformfield(
                        controller: name,
                        label: '*',
                        bottomLineColor: Color(0xffb8b8b8),
                        hinttext: AppLocalizations.of(context)!.name,
                        suffixIcon: Icon(Icons.person),
                        newIcon:
                            Icon(Icons.person, color: appcolor.SufixIconColor),
                        // border: InputBorder.none,
                        key_type: TextInputType.visiblePassword,
                      ),
                    ),
                    Container(
                      height: Get.height * 0.055,
                      child: customtextformfield(
                        controller: mobileNo,
                        label: '*',
                        bottomLineColor: Color(0xffb8b8b8),
                        hinttext: AppLocalizations.of(context)!.phoneNumber,
                        suffixIcon: Icon(
                          Icons.call,
                        ),
                        newIcon:
                            Icon(Icons.call, color: appcolor.SufixIconColor),
                        key_type: TextInputType.phone,
                        maxLength: 10,
                      ),
                    ),
                    Container(
                      height: Get.height * 0.055,
                      child: customtextformfield(
                        controller: password,
                        label: '*',
                        bottomLineColor: Color(0xffb8b8b8),
                        hinttext: AppLocalizations.of(context)!.createpassword,
                        suffixIcon: Icon(Icons.lock_open),
                        showPassword: controller.showPassword.value,
                        callback: () {
                          controller.showPassword.value =
                              !controller.showPassword.value;
                          setState(() {});
                        },
                        newIcon: Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                        key_type: TextInputType.visiblePassword,
                      ),
                    ),
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.85,
                      child: TextFormField(
                        controller: referralCode,
                        // initialValue: "KISSAN",
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xffb8b8b8))),
                          hintText: AppLocalizations.of(context)!.code,
                          label: Text("Referral Code"),
                          suffixIcon: Icon(
                            Icons.code_off,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GradientText(
                          gradient: appcolor.gradient,
                          widget: Text(
                            AppLocalizations.of(context)!.yourprofession,
                            style: TextStyle(
                                fontSize: 18, color: appcolor.redColor),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 10),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => Container(
                        height: Get.height * 0.03,
                        child: Row(
                          children: [
                            Radio(
                              value: 'electrician',
                              groupValue: controller.groupValue.value,
                              onChanged: (val) {
                                controller.groupValue.value = val.toString();
                              },
                              fillColor: MaterialStateColor.resolveWith(
                                (states) => appcolor.mixColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  controller.groupValue.value = 'electrician';
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.electrician,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Radio(
                              value: 'dealer',
                              groupValue: controller.groupValue.value,
                              onChanged: (val) {
                                setState(() {
                                  controller.groupValue.value = val.toString();
                                });
                              },
                              fillColor: MaterialStateColor.resolveWith(
                                (states) => appcolor.mixColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  controller.groupValue.value = 'dealer';
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.dealer,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(color: appcolor.redColor),
                                  )
                                ],
                              ),
                            ),
                            Radio(
                              value: 'partner',
                              groupValue: controller.groupValue.value,
                              onChanged: (val) {
                                controller.groupValue.value = val.toString();
                              },
                              fillColor: MaterialStateColor.resolveWith(
                                (states) => appcolor.mixColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  controller.groupValue.value = 'partner';
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.partner,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => customwidget(
                        controller.groupValue.value,
                        bussinessName,
                        dealerPartnerCin,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          // fillColor: Colors.red,
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isSelected = value!;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Text(AppLocalizations.of(context)!.iagree),
                            TextButton(
                              onPressed: () {
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
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text('data not found'),
                                              );
                                            } else if (snapshot.hasData) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 0),
                                                  child: Html(
                                                    data:
                                                        """${snapshot.data['data']}""",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
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
                                                setState(() {
                                                  isSelected = true;
                                                });
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
                              child: Text(AppLocalizations.of(context)!
                                  .termsAndConditions),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: Get.height * 0.055,
                      child: blockButton(
                        callback: () {
                          otps = random(100000, 999999);
                          //print(otps);
                          // makePostRequest();
                          var Name = name.text.trim().toString();
                          var Password = password.text.trim().toString();
                          var MobileNo = mobileNo.text.trim();
                          var BussinessName =
                              bussinessName.text.trim().toString();
                          var cin = dealerPartnerCin.text.trim();
                          
                          if (Name == '' && Password == '' && MobileNo == '') {
                            return alertBoxdialogBox(
                                context, 'Alert', 'Please fill Field');
                          } else if (MobileNo.length < 10) {
                            alertBoxdialogBox(context, 'Alert',
                                'The Mobile Number Must be 10 Digits.');
                          }
                          // else if(BussinessName == ''){
                          //   alertBoxdialogBox(context, 'Alert', 'Enter Bussiness Name' );
                          //
                          // }

                          else if (Name != '' &&
                              Password != '' &&
                              MobileNo != '') {
                            if (isSelected == false) {
                              return alertBoxdialogBox(context, 'Alert',
                                  'Please agree term and condition');
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                              // otp(MobileNo,otps);
                              otp(MobileNo, otps, Name, Password, BussinessName,
                                  cin);
                            }
                          }
                          // Get.to(Home_view());
                        },
                        width: Get.width * 0.35,
                        widget: isLoading
                            ? SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                            : Text(
                                AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2),
                              ),
                        verticalPadding: 3,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: GradientText(
                            widget: Text(
                              '${AppLocalizations.of(context)!.havekissanaccount}? ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            gradient: appcolor.gradient,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAll(login_view());
                          },
                          child: Stack(
                            children: [
                              Container(
                                child: GradientText(
                                  widget: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 15,
                                      color: appcolor.redColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  gradient: appcolor.gradient,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Container(
                      height: Get.height * 0.25,
                      child: Image(
                        image: AssetImage(
                          'assets/imgpsh_fullsize_anim 1.png',
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
      ),
    );
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future otp(String phonNumber, OTP, Name, Password, BussinessName, cin) async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
            'http://nimbusit.biz/api/SmsApi/SendSingleApi?UserID=HariDayabiz&Password=blzx1639BL&SenderID=KSNHDI&Phno=$phonNumber&Msg=Hi, Your OTP for Kisaan Parivar App is $OTP. This OTP is valid for 5 minutes.&EntityID=1701170324305196194&TemplateID=1707170332162391890'),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Status'] == "OK") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data['Response']['Message']}')));
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: Get.height * 0.43,
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
                          'OTP VERIFICATION',
                          style: TextStyle(
                              color: Color.fromRGBO(53, 53, 52, 1),
                              fontSize: 24,
                              fontFamily: 'Nunito-Regular.ttf',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Verify Your Mobile Number',
                          style: TextStyle(
                              color: Color.fromRGBO(53, 53, 52, 1),
                              fontSize: 16,
                              fontFamily: 'Nunito-Regular.ttf',
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Verify your mobile number',
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
                              Matchs = pin;
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
                            text: 'Dont receive OTP ',
                            style: TextStyle(color: Colors.black),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: 'Resend',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 40.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              var sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setBool('login', true);
                              if (Matchs.toString() == OTP.toString()) {
                                var value = {
                                  "name": Name,
                                  "password": Password,
                                  "mobile_no": phonNumber,
                                  "profession": controller.groupValue.value,
                                  "business_name": BussinessName,
                                  "identification_id": cin
                                };
                                registration(value);
                                Navigator.pop(context);
                              } else {
                                alertBoxdialogBox(
                                  context,
                                  'Alert',
                                  'OTP did not match',
                                );
                                // logIn(Email, );
                              }
                            },
                            child: Text('Submit',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'nunito')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appcolor.redColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // <-- Radius
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    }
  }

  Future registration(Object value) async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse('${apiDomain().domain}register'),
        body: jsonEncode(value),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        var Token = data['data']['token'];
        Get.offAll(login_view());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data['message']}')));
        // prefs.setString('token', Token);
      } else if (data['success'] == false) {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
    }
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
}

Widget customwidget(
  String type,
  TextEditingController bussinessName,
  TextEditingController dealerPartnerCin,
) {
  //electric
  if (type == 'electrician') {
    return Container(
      height: Get.height * 0.055,
      child: customtextformfield(
        controller: dealerPartnerCin,
        hinttext: 'Dealer/Partner CODE',
        bottomLineColor: Color(0xffb8b8b8),
        key_type: TextInputType.visiblePassword,
      ),
    );
  } else if (type == 'dealer') {
    return Container(
      child: Column(
        children: [
          Container(
              height: Get.height * 0.055,
              child: customtextformfield(
                controller: bussinessName,
                hinttext: 'Business Name',
                bottomLineColor: Color(0xffb8b8b8),
                key_type: TextInputType.visiblePassword,
              )),
          Container(
              height: Get.height * 0.055,
              child: customtextformfield(
                controller: dealerPartnerCin,
                hinttext: 'Partner CODE',
                bottomLineColor: Color(0xffb8b8b8),
                key_type: TextInputType.visiblePassword,
              )),
        ],
      ),
    );
  } else {
    return Container(
      height: Get.height * 0.055,
      child: customtextformfield(
        controller: bussinessName,
        hinttext: 'Business Name',
        bottomLineColor: Color(0xffb8b8b8),
        key_type: TextInputType.visiblePassword,
      ),
    );
  }
}
