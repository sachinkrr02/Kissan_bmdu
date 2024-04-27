import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/wallet/view/redemption_view.dart';
import 'package:kisaan_electric/wallet/view/tds_certificate_view.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AlertDialogBox/alertBoxContent.dart';
import '../../home/view/home_view.dart';
import '../../scheme/view/schemes_view.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class wallet_view extends StatefulWidget {
  const wallet_view({super.key});

  @override
  State<wallet_view> createState() => _wallet_viewState();
}

class _wallet_viewState extends State<wallet_view> {
  TextEditingController totalPoints = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var value = null;
  int total = 0;
  var totalamount;
  int dropDownValue = 0;
  RxBool showContainer = false.obs;
  var dropdown = '';
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
        child: WillPopScope(
          onWillPop: () async {
            Get.offAll(Home_view());
            return true;
          },
          child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.white,
            //   automaticallyImplyLeading: false,
            //   title: customAppBar('My Wallet','1'),),
            // backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  customAppBar(
                      '${AppLocalizations.of(context)!.myWallet}', '1'),
                  Container(
                    height: 1,
                    width: Get.width,
                    color: appcolor.borderColor,
                  ),
                  FutureBuilder(
                    future: PointHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Data not found'),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        var data = snapshot.data;
                        var date = data['register_at'].split('T');
                        var split = date[0];
                        var datechange = split.split('-');
                        var totals =
                            '${double.parse(data['Point_Value'].toString()) * total}';
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              // Container(
                              //     margin: EdgeInsets.only(bottom: 15),
                              //     height: Get.height * 0.04,
                              //     width: Get.width,
                              //     color: appcolor.newRedColor,
                              //     child:Marquee(
                              //       text: 'Approval pending with Kisaan Electric ', style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 20,
                              //     ),
                              //
                              //       scrollAxis: Axis.horizontal,
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       blankSpace: 20.0,
                              //       velocity: 100.0,
                              //       pauseAfterRound: Duration(seconds: 1),
                              //       startPadding: 10.0,
                              //       accelerationDuration: Duration(seconds: 1),
                              //       accelerationCurve: Curves.linear,
                              //       decelerationDuration: Duration(milliseconds: 500),
                              //       decelerationCurve: Curves.easeOut,
                              //     )
                              //
                              // ),
                              SizedBox(height: 20),
                              Text(
                                '${AppLocalizations.of(context)!.registeredOn} : ${datechange[2]}-${datechange[1]}-${datechange[0]}',
                                style: TextStyle(
                                  height: 0.8,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GradientText(
                                gradient: appcolor.gradient,
                                widget: Text(
                                  '${AppLocalizations.of(context)!.balancePoints} : ${data['Total_point']}',
                                  style: TextStyle(
                                      height: 1.2,
                                      fontSize: 16,
                                      color: appcolor.redColor),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GradientText(
                                        gradient: appcolor.gradient,
                                        widget: Text(
                                          AppLocalizations.of(context)!
                                              .panStatus,
                                          style: TextStyle(
                                            height: 0.8,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                          height: Get.height * 0.045,
                                          width: Get.width * 0.3,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    data['Pan_status'] == false
                                                        ? appcolor.redColor
                                                        : Colors.green),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            //  color:data['Pan_status']==false? appcolor.redColor: Colors.green
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${data['Pan_status'] == false ? AppLocalizations.of(context)!.pending : AppLocalizations.of(context)!.approved}',
                                              style: TextStyle(
                                                  color: data['Pan_status'] ==
                                                          false
                                                      ? appcolor.redColor
                                                      : Colors.green,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.2),
                                            ),
                                          )),
                                    ],
                                  ).paddingOnly(
                                    bottom: 10,
                                  ),
                                  Row(
                                    children: [
                                      GradientText(
                                        gradient: appcolor.gradient,
                                        widget: Text(
                                          AppLocalizations.of(context)!
                                              .bankStatus,
                                          style: TextStyle(
                                            height: 0.8,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                          height: Get.height * 0.045,
                                          width: Get.width * 0.3,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    data['Bank_status'] == false
                                                        ? appcolor.redColor
                                                        : Colors.green),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            // color:data['Bank_status']==false? appcolor.redColor: Colors.green
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${data['bank_status'] == false ? AppLocalizations.of(context)!.pending : AppLocalizations.of(context)!.approved}',
                                              style: TextStyle(
                                                  color: data['Bank_status'] ==
                                                          false
                                                      ? appcolor.redColor
                                                      : Colors.green,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.2),
                                            ),
                                          )),
                                    ],
                                  ).paddingOnly(
                                    bottom: 15,
                                  ),
                                  Row(
                                    children: [
                                      GradientText(
                                        gradient: appcolor.gradient,
                                        widget: Text(
                                          AppLocalizations.of(context)!
                                              .aadharStatus,
                                          style: TextStyle(
                                            height: 0.8,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                          height: Get.height * 0.045,
                                          width: Get.width * 0.3,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: data['aadhar_status'] ==
                                                        false
                                                    ? appcolor.redColor
                                                    : Colors.green),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            // color:data['aadhar_status']==false? appcolor.redColor: Colors.green
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${data['aadhar_status'] == false ? AppLocalizations.of(context)!.pending : AppLocalizations.of(context)!.approved}',
                                              style: TextStyle(
                                                  color:
                                                      data['aadhar_status'] ==
                                                              false
                                                          ? appcolor.redColor
                                                          : Colors.green,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.2),
                                            ),
                                          )),
                                    ],
                                  ).paddingOnly(
                                    bottom: 15,
                                  ),
                                  data['profession'] == 'electrician'
                                      ? Container(
                                          height: 0,
                                          width: 0,
                                        )
                                      : Row(
                                          children: [
                                            GradientText(
                                              gradient: appcolor.gradient,
                                              widget: Text(
                                                'GST Status',
                                                style: TextStyle(
                                                  height: 0.8,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                                height: Get.height * 0.045,
                                                width: Get.width * 0.3,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          data['gst_status'] ==
                                                                  false
                                                              ? appcolor
                                                                  .redColor
                                                              : Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    30,
                                                  ),
                                                  //color:data['gst_status']==false? appcolor.redColor: Colors.green
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${data['gst_status'] == false ? AppLocalizations.of(context)!.pending : AppLocalizations.of(context)!.approved}',
                                                    style: TextStyle(
                                                        color:
                                                            data['gst_status'] ==
                                                                    false
                                                                ? appcolor
                                                                    .redColor
                                                                : Colors.green,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1.2),
                                                  ),
                                                )),
                                          ],
                                        ).paddingOnly(
                                          bottom: 15,
                                        ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: Get.height * 0.055,
                                        child: blockButton(
                                          callback: () {
                                            // Get.to(tds_certificate_view());
                                          },
                                          width: Get.width * 0.3,
                                          widget: Text(
                                            AppLocalizations.of(context)!
                                                .tdsDetails,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.2),
                                          ),
                                          verticalPadding: 3,
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(
                                    bottom: 15,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DottedBorder(
                                        borderType: BorderType.RRect,
                                        color: appcolor.newRedColor,
                                        radius: Radius.circular(10),
                                        child: Container(
                                          width: Get.width * 0.42,
                                          decoration: BoxDecoration(
                                            color: appcolor.greyColor,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .cash,
                                              style: TextStyle(
                                                  fontSize: 20, height: 1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(schemes_view());
                                        },
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: appcolor.newRedColor,
                                          radius: Radius.circular(10),
                                          child: Container(
                                            width: Get.width * 0.42,
                                            decoration: BoxDecoration(
                                              color: appcolor.greyColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .scheme,
                                                style: TextStyle(
                                                    fontSize: 20, height: 1.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(
                                    bottom: 15,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .selectRedeemMethod,
                                    style: TextStyle(
                                      height: 1.2,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        border:
                                            Border.all(color: Colors.black)),
                                    height: Get.height * 0.065,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Center(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField(
                                            hint: Text('Select Reedem Method'),
                                            focusColor: Colors.red,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none
                                                // UnderlineInputBorder(
                                                //     borderSide:
                                                //     BorderSide(color: Colors.white))
                                                ),
                                            elevation: 10,
                                            //  iconSize: 5.0,
                                            value: dropDownValue,
                                            onChanged: (newVal) {
                                              dropDownValue = newVal!;
                                              print(newVal);
                                            },
                                            items: [
                                              DropdownMenuItem(
                                                value: 0,
                                                child: Text('Bank'),
                                              ),
                                              DropdownMenuItem(
                                                value: 1,
                                                child: Text('Paytm'),
                                              ),
                                              DropdownMenuItem(
                                                value: 2,
                                                child: Text('GooglePay'),
                                              ),
                                              DropdownMenuItem(
                                                value: 3,
                                                child: Text('PhonePay'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Center(
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            // padding: EdgeInsets.only(top: 4),
                                            height: Get.height * 0.06,
                                            width: Get.width * 0.5,
                                            decoration: BoxDecoration(
                                                color: Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: appcolor.newRedColor,
                                                )),
                                            child: TextFormField(
                                              controller: totalPoints,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              cursorColor: Colors.black,
                                              cursorHeight: 0,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 24,
                                              ),
                                              onChanged: (value) {
                                                // Parse the entered value as a double
                                                var enteredValue =
                                                    int.parse(value);
                                                int totalamounts =
                                                    data['Total_point'];

                                                // Limit the value to 100
                                                if (enteredValue >
                                                    totalamounts) {
                                                  setState(() {
                                                    totalPoints.text =
                                                        '$totalamounts';
                                                  });
                                                }
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                border: InputBorder.none,
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .enterPoints,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 6),
                                                hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    height: 2.5,
                                                    color: Colors.black),
                                              ),
                                              validator: (value) {
                                                //   var enteredValue = int.parse(value);
                                                int totalamounts =
                                                    data['Total_point'];
                                                if (value == 0) {
                                                  return 'Your Points 0';
                                                }
                                                // You can add additional validation logic here
                                                return null; // Return null if the input is valid
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.maximumLimit}  : Rs. ${data['dail_limit']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              height: 0.8,
                                            ),
                                          ),
                                          // Text(
                                          //   'One Points Value : Rs. ${data['Point_Value']}',
                                          //   style: TextStyle(fontSize: 16, height: 1.2),
                                          // ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: Get.height * 0.055,
                                            child: blockButton(
                                              callback: () {
                                                var Point =
                                                    totalPoints.text.trim();
                                                var limitamount = double.parse(
                                                    data['dail_limit']
                                                        .toString());
                                                setState(() {
                                                  totalamount = double.parse(
                                                          data['Point_Value']
                                                              .toString()) *
                                                      int.parse(Point);
                                                });
                                                var apiobject = {
                                                  "amount": totalamount,
                                                  "point": Point,
                                                  "payment_mode":
                                                      dropDownValue == 0
                                                          ? 'bank'
                                                          : dropDownValue == 1
                                                              ? 'paytm'
                                                              : dropDownValue ==
                                                                      2
                                                                  ? 'googlepay'
                                                                  : 'phonepay'
                                                };
                                                if (Point != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            '${limitamount > totalamount ? 'Sorry' : 'Please Conform'}',
                                                            style: TextStyle(
                                                                color: appcolor
                                                                    .redColor),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Total Amount: Rs.$totalamount'),
                                                              Text(
                                                                '${limitamount > totalamount ? 'Minimum Limit ${data['dail_limit']}' : ''}',
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor),
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      Get.height *
                                                                          0.055,
                                                                  child:
                                                                      blockButton(
                                                                    callback:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    width:
                                                                        Get.width *
                                                                            0.3,
                                                                    widget:
                                                                        Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          height:
                                                                              1.2),
                                                                    ),
                                                                    verticalPadding:
                                                                        3,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Get.height *
                                                                          0.055,
                                                                  child:
                                                                      blockButton(
                                                                    callback:
                                                                        () {
                                                                      //  Navigator.pop(context);
                                                                      if (limitamount >
                                                                          totalamount) {
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        AddationInfoUpdate(
                                                                            apiobject);
                                                                        Future.delayed(
                                                                            Duration(seconds: 1),
                                                                            () {
                                                                          Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => wallet_view()));
                                                                        });
                                                                      }
                                                                    },
                                                                    width:
                                                                        Get.width *
                                                                            0.3,
                                                                    widget:
                                                                        Text(
                                                                      'Ok',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          height:
                                                                              1.2),
                                                                    ),
                                                                    verticalPadding:
                                                                        3,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                } else if (showContainer
                                                        .value ==
                                                    null) {
                                                  alertBoxdialogBox(
                                                      context,
                                                      'Alert',
                                                      'Please Select Payment Method');
                                                } else {
                                                  alertBoxdialogBox(context,
                                                      'Alert', 'Enter Point');
                                                }
                                              },
                                              width: Get.width * 0.3,
                                              widget: Text(
                                                AppLocalizations.of(context)!
                                                    .redeem,
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
                                      ).paddingOnly(
                                        top: 20,
                                      ),
                                    ),
                                  )
                                  // Obx(
                                  //       () => Container(
                                  //     child: Stack(
                                  //       children: [
                                  //         Container(
                                  //           padding: EdgeInsets.symmetric(horizontal: 20),
                                  //           height: Get.height * 0.07,
                                  //           decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //               color: showContainer.value == false
                                  //                   ? Colors.black
                                  //                   : appcolor.newRedColor,
                                  //             ),
                                  //             color: Colors.transparent,
                                  //             borderRadius: BorderRadius.circular(5),
                                  //           ),
                                  //           child: Center(
                                  //             child: DropdownButtonFormField(
                                  //               decoration: InputDecoration.collapsed(
                                  //                 hintText: 'Select Method',
                                  //                 hintStyle: TextStyle(
                                  //                   color: Colors.black,
                                  //                   fontSize: 16,
                                  //                   height: 2.5,
                                  //                 ),
                                  //               ),
                                  //               value: value,
                                  //               onChanged: (value) {
                                  //                 showContainer.value = !showContainer.value;
                                  //               },
                                  //               items: [
                                  //                 DropdownMenuItem(
                                  //                   child: Text(
                                  //                     'Google Pay',
                                  //                     style: TextStyle(
                                  //                       fontSize: 14,
                                  //                     ),
                                  //                   ),
                                  //                   value: 1,
                                  //                 ),
                                  //                 DropdownMenuItem(
                                  //                     child: Text(
                                  //                       'Paytm',
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                       ),
                                  //                     ),
                                  //                     value: 2),
                                  //                 DropdownMenuItem(
                                  //                   child: Text(
                                  //                     'Phone Pay',
                                  //                     style: TextStyle(
                                  //                       fontSize: 14,
                                  //                     ),
                                  //                   ),
                                  //                   value: 3,
                                  //                 ),
                                  //                 DropdownMenuItem(
                                  //                   child: Text(
                                  //                     'Bank',
                                  //                     style: TextStyle(
                                  //                       fontSize: 14,
                                  //                     ),
                                  //                   ),
                                  //                   value: 4,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           padding: EdgeInsets.symmetric(horizontal: 3),
                                  //           margin: EdgeInsets.only(left: 10),
                                  //           decoration: BoxDecoration(
                                  //             color: appcolor.greyColor,
                                  //           ),
                                  //           child: Text(
                                  //             'Select Reedem Method',
                                  //             style: TextStyle(
                                  //               height: 0.5,
                                  //               fontSize: 14,
                                  //               color: showContainer.value == false
                                  //                   ? Colors.black
                                  //                   : appcolor.black,
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // //show container
                                  // Obx(
                                  //       () => showContainer.value == true
                                  //       ? Form(
                                  //         key: _formKey,
                                  //         child: Column(
                                  //     children: [
                                  //         Container(
                                  //           // padding: EdgeInsets.only(top: 4),
                                  //           height: Get.height * 0.06,
                                  //           width: Get.width * 0.5,
                                  //           decoration: BoxDecoration(
                                  //               color: Color(0xffFFFFFF),
                                  //               borderRadius: BorderRadius.circular(20),
                                  //               border: Border.all(
                                  //                 color: appcolor.newRedColor,
                                  //               )),
                                  //           child: TextFormField(
                                  //             controller: totalPoints,
                                  //             keyboardType: TextInputType.number,
                                  //             textAlign: TextAlign.center,
                                  //             cursorColor: Colors.black,
                                  //
                                  //             cursorHeight: 0,
                                  //             style: TextStyle(
                                  //               color: Colors.black,
                                  //               fontSize: 24,
                                  //             ),
                                  //             onChanged: (value) {
                                  //               // Parse the entered value as a double
                                  //               var enteredValue = int.parse(value);
                                  //               int totalamounts = data['Total_point'];
                                  //
                                  //               // Limit the value to 100
                                  //               if (enteredValue > totalamounts) {
                                  //                 setState(() {
                                  //                   totalPoints.text = '$totalamounts';
                                  //                 });
                                  //               }
                                  //             },
                                  //             decoration: InputDecoration(
                                  //
                                  //                 enabledBorder: InputBorder.none,
                                  //                 disabledBorder: InputBorder.none,
                                  //                 border: InputBorder.none,
                                  //                 hintText: 'Enter Points',
                                  //                 contentPadding:
                                  //                 EdgeInsets.symmetric(vertical: 6),
                                  //                 hintStyle: TextStyle(
                                  //                     fontSize: 20,
                                  //                     height: 2.5,
                                  //                     color: Colors.black
                                  //                 ),),
                                  //             validator: (value) {
                                  //               //   var enteredValue = int.parse(value);
                                  //               int totalamounts = data['Total_point'];
                                  //               if (value == 0) {
                                  //                 return 'Your Points 0';
                                  //               }
                                  //               // You can add additional validation logic here
                                  //               return null; // Return null if the input is valid
                                  //             },
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           height: 20,
                                  //         ),
                                  //         Text(
                                  //           'Daily Limit for Electrician : Rs. ${data['dail_limit']}',
                                  //           style: TextStyle(
                                  //             fontSize: 16,
                                  //             height: 0.8,
                                  //           ),
                                  //         ),
                                  //         Text(
                                  //           'One Points Value : Rs. ${data['Point_Value']}',
                                  //           style: TextStyle(fontSize: 16, height: 1.2),
                                  //         ),
                                  //         SizedBox(height: 10,),
                                  //         // Text(
                                  //         //   'Daily Limit for Dealers : Rs. 250',
                                  //         //   style: TextStyle(
                                  //         //     fontSize: 16,
                                  //         //     height: 0.8,
                                  //         //   ),
                                  //         // ),
                                  //         Container(
                                  //           height: Get.height * 0.055,
                                  //           child: blockButton(
                                  //             callback: () {
                                  //               var Point =totalPoints.text.trim();
                                  //               var limitamount = double.parse(data['dail_limit']);
                                  //               setState(() {
                                  //                 totalamount = double.parse(data['Point_Value']) * int.parse(Point);
                                  //               });
                                  //               var apiobject = {
                                  //                 "amount": totalamount,
                                  //                 "point":Point,
                                  //                 "payment_mode":showContainer.value.toString()
                                  //               };
                                  //               if(Point != null ){
                                  //                 showDialog(context: context, builder: (context){
                                  //                   return AlertDialog(
                                  //                     title: Text('${totalamount >= limitamount?'Sorry':'Congrulation'}',style: TextStyle(color: appcolor.redColor),),
                                  //                     content: Column(
                                  //                       mainAxisSize: MainAxisSize.min,
                                  //                       children: [
                                  //                         Text('Total Amount: Rs.$totalamount'),
                                  //                         Text('${totalamount >= limitamount?'Out of Limit':''}',style: TextStyle(color: appcolor.redColor),),
                                  //                       ],
                                  //                     ),
                                  //                     actions: [
                                  //                       Container(
                                  //                         height: Get.height * 0.055,
                                  //
                                  //                         child: blockButton(
                                  //                           callback: () {
                                  //                             Navigator.pop(context);
                                  //                           },
                                  //                           width: Get.width * 0.3,
                                  //                           widget: Text(
                                  //                             'Cancel',
                                  //                             style: TextStyle(
                                  //                                 color: Colors.white,
                                  //                                 fontSize: 15,
                                  //                                 fontWeight: FontWeight.bold,
                                  //                                 height: 1.2),
                                  //                           ),
                                  //                           verticalPadding: 3,
                                  //                         ),
                                  //                       ),
                                  //                       SizedBox(width: 10,),
                                  //                       Container(
                                  //                         height: Get.height * 0.055,
                                  //
                                  //                         child: blockButton(
                                  //                           callback: () {
                                  //                             Navigator.pop(context);
                                  //                             if(totalamount >= limitamount){
                                  //                               Navigator.pop(context);
                                  //                             }else{
                                  //                               AddationInfoUpdate(apiobject);
                                  //                             }
                                  //                           },
                                  //                           width: Get.width * 0.3,
                                  //                           widget: Text(
                                  //                             'Ok',
                                  //                             style: TextStyle(
                                  //                                 color: Colors.white,
                                  //                                 fontSize: 15,
                                  //                                 fontWeight: FontWeight.bold,
                                  //                                 height: 1.2),
                                  //                           ),
                                  //                           verticalPadding: 3,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   );
                                  //                 });
                                  //               }else if(showContainer.value == null){
                                  //                 alertBoxdialogBox(context, 'Alert', 'Please Select Payment Method');
                                  //               }
                                  //
                                  //               else {
                                  //                 alertBoxdialogBox(context, 'Alert', 'Enter Point');
                                  //               }
                                  //             },
                                  //             width: Get.width * 0.3,
                                  //             widget: Text(
                                  //               'Reedem',
                                  //               style: TextStyle(
                                  //                   color: Colors.white,
                                  //                   fontSize: 15,
                                  //                   fontWeight: FontWeight.bold,
                                  //                   height: 1.2),
                                  //             ),
                                  //             verticalPadding: 3,
                                  //           ),
                                  //         ),
                                  //     ],
                                  //   ).paddingOnly(
                                  //     top: 20,
                                  //   ),
                                  //       )
                                  //       : Container()
                                  // ),
                                ],
                              ).paddingSymmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: floatingActionButon(context),
          ),
        ),
      ),
    );
  }

  Future PointHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response =
        await http.post(Uri.parse('${apiDomain().domain}walletinfo'),
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

  Future AddationInfoUpdate(Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(value);

    final response =
        await http.post(Uri.parse('${apiDomain().domain}walletinfo'),
            body: jsonEncode(value),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        // Get.offAll(Home_view());
        alertBoxdialogBox(context, 'Congrulation', '${data['data']}');
        totalPoints.text = '';
      } else if (data['status'] == false) {
        alertBoxdialogBox(context, 'Alert', '${data['data']}');
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['data']}');
      }
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
