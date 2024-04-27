import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/History/tansitonFilter.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/wallet/view/redemption_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../products/controller/product_controller.dart';
import '../server/apiDomain.dart';
import '../whatsaapIcon/WhatsaapIcon.dart';
import 'PointsFilter.dart';
import 'SearachOrder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class historyView extends StatefulWidget {
  final condition;
  const historyView({super.key, this.condition});
  @override
  State<historyView> createState() => _historyViewState();
}

class _historyViewState extends State<historyView> {
  productController controller = Get.put(productController());
  DateTime _dateTime = DateTime.now();
  DateTime _EndateTime = DateTime.now();
  var total = 0;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  var totalvalue = 0;
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
    setState(() {
      totalvalue = total;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _datepicker() async {
    showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  void _Enddatepicker() async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _EndateTime = value!;
      });
    });
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
          body: Column(
            children: [
              customAppBar(AppLocalizations.of(context)!.history, ''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              Container(
                decoration: BoxDecoration(),
                height: Get.height * 0.08,
                child: TabBar(
                  dividerColor: appcolor.newRedColor,
                  indicatorPadding: EdgeInsets.zero,
                  unselectedLabelColor: Colors.black,
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  indicatorColor: appcolor.redColor,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  controller: controller.tabcontroller,
                  tabs: [
                    Container(
                      child: Text(
                        AppLocalizations.of(context)!.points,
                      ),
                    ),
                    Container(
                      child: Text(
                        AppLocalizations.of(context)!.cashTransactions,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          AppLocalizations.of(context)!.schemeTransactions,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    widget.condition['profession'].toString() == 'dealer'
                        ? Container(
                            child: Text(AppLocalizations.of(context)!.orders))
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              ),
              Expanded(
                child:
                    TabBarView(controller: controller.tabcontroller, children: [
                  points(),
                  Transition(),
                  redemption_view(),
                  widget.condition['profession'] == 'dealer'
                      ? Order()
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ]),
              )
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  Future PointHistory(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }
  }

  Widget points() {
    // void main() {
    //  FutureBuilder(
    //    future: PointHistory(),
    //    builder: (context,snapshot){
    //      if(snapshot.hasData){
    //        int sum=0;
    //        snapshot.data.forEach((e){
    //          sum+=e;
    //        });
    //        return sum;
    //      }
    //      return sum;
    //    },
    //  );
    //
    // }
    return FutureBuilder(
        future: PointHistory('pointhistory'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Data Not Found');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // InkWell(
                //     //   onTap: (){
                //     //     showSearch(context: context, delegate: Searchpage());
                //     //   },
                //     //   child: Container(
                //     //     decoration: BoxDecoration(
                //     //       border: Border.all(
                //     //         color: appcolor.newRedColor,
                //     //       ),
                //     //       borderRadius: BorderRadius.circular(
                //     //         10,
                //     //       ),
                //     //     ),
                //     //     width: Get.width * 0.6,
                //     //     height: Get.height * 0.05,
                //     //     child: Center(
                //     //       child: Row(
                //     //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     //         children: [
                //     //           Text('Code Search'),
                //     //           Icon(Icons.search,color: Colors.red,)
                //     //         ],
                //     //       ),
                //     //     )
                //     //   ),
                //     // ),
                //     // Row(
                //     //   children: [
                //     //     Text(
                //     //       'Total Points ',
                //     //       style: TextStyle(
                //     //         fontSize: 14,
                //     //         height: 1,color: appcolor.redColor
                //     //       ),
                //     //     ),
                //     //     Text(
                //     //       '${total}',
                //     //       style: TextStyle(
                //     //         fontSize: 14,
                //     //         height: 1,
                //     //       ),
                //     //     ),
                //     //   ],
                //     // ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.filter} :',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _datepicker();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appcolor.newRedColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          width: Get.width * 0.26,
                          height: Get.height * 0.04,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_dateTime == null ? 'Date From: ' : '${_dateTime.day}-${_dateTime.month}-${_dateTime.year}'} ',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: appcolor.black,
                                    height: 1,
                                  ),
                                ),
                                GradientText(
                                  gradient: appcolor.gradient,
                                  widget: Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        _Enddatepicker();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appcolor.newRedColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          width: Get.width * 0.26,
                          height: Get.height * 0.04,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_EndateTime == DateTime.now() ? 'Date To: ' : '${_EndateTime.day}-${_EndateTime.month}-${_EndateTime.year}'}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: appcolor.black,
                                    height: 1,
                                  ),
                                ),
                                GradientText(
                                  gradient: appcolor.gradient,
                                  widget: Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    blockButton(
                      verticalPadding: 3,
                      width: Get.width * 0.2,
                      callback: () {
                        Get.to(PointsFiler(
                          conditon: 1,
                          url: 'pointhistoryFilter',
                          startDate:
                              '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}',
                          enddate:
                              '${_EndateTime.year}-${_EndateTime.month}-${_EndateTime.day}',
                        ));
                      },
                      widget: Text(
                        AppLocalizations.of(context)!.submit,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Table(border: TableBorder.all(), children: [
                  TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.date,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.scanCode,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text(AppLocalizations.of(context)!.referenceCode,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.points,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ]),
                  // TableRow(
                  //     children :[
                  //       Text('Date',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                  //       Text('${data['QR_Code']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                  //       Text('${data['Reference']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                  //       Text('${data['Point']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                  //     ]),
                ]),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data[index];
                        var date = data['created_at'];
                        var splits = date.split('T');
                        var splity = splits[0];
                        var date1 = splity.split('-');
                        // total += int.parse(data['Point'].toString());

                        return Table(border: TableBorder.all(), children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${date1[2]}-${date1[1]}-${date1[0]}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .detail),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .date,
                                                          style: TextStyle(
                                                              color: appcolor
                                                                  .redColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${date1[2]}-${date1[1]}-${date1[0]}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .scanCode,
                                                          style: TextStyle(
                                                              color: appcolor
                                                                  .redColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${data['QR_Code'] == null ? '' : data['QR_Code']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .referenceCode,
                                                          style: TextStyle(
                                                              color: appcolor
                                                                  .redColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${data['Reference'] == null ? '' : data['Reference']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .points,
                                                          style: TextStyle(
                                                              color: appcolor
                                                                  .redColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${data['Point'] == null ? '' : data['Point']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  blockButton(
                                                      callback: () {
                                                        Get.back();
                                                      },
                                                      widget: Text(
                                                        'Ok',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      width: Get.width)
                                                ],
                                              );
                                            });
                                      },
                                      child: Text(
                                        '${data['QR_Code'] == null ? '' : data['QR_Code'].length < 7 ? "${data['QR_Code']}" : '${data['QR_Code']}'.toString().substring(0, 7)}..',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${data['Reference'] == null ? '' : data['Reference']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['Point']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                              ]),
                          // TableRow(
                          //     children :[
                          //       Text('Date',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //       Text('${data['QR_Code']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //       Text('${data['Reference']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //       Text('${data['Point']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //     ]),
                        ]);
                      }),
                )
              ],
            ).paddingSymmetric(
              horizontal: 10,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget Transition() {
    return FutureBuilder(
        future: PointHistory('transactionhistory'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Data Not Found');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     InkWell(
                //       onTap: (){
                //         showSearch(context: context, delegate: Searchpagetranstion());
                //       },
                //       child: Container(
                //           decoration: BoxDecoration(
                //             border: Border.all(
                //               color: appcolor.newRedColor,
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               10,
                //             ),
                //           ),
                //           width: Get.width * 0.6,
                //           height: Get.height * 0.05,
                //           child: Center(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: [
                //                 Text('Code Search'),
                //                 Icon(Icons.search,color: Colors.red,)
                //               ],
                //             ),
                //           )
                //       ),
                //     ),
                //     Row(
                //       children: [
                //         Text(
                //           'Total Points ',
                //           style: TextStyle(
                //             fontSize: 12,
                //             height: 1,
                //           ),
                //         ),
                //         Text(
                //           '${total}',
                //           style: TextStyle(
                //             fontSize: 12,
                //             height: 1,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.filter} :',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _datepicker();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appcolor.newRedColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          width: Get.width * 0.26,
                          height: Get.height * 0.04,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_dateTime == null ? 'Date From: ' : '${_dateTime.day}-${_dateTime.month}-${_dateTime.year}'} ',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: appcolor.black,
                                    height: 1,
                                  ),
                                ),
                                GradientText(
                                  gradient: appcolor.gradient,
                                  widget: Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        _Enddatepicker();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appcolor.newRedColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          width: Get.width * 0.26,
                          height: Get.height * 0.04,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_EndateTime == DateTime.now() ? 'Date To: ' : '${_EndateTime.day}-${_EndateTime.month}-${_EndateTime.year}'}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: appcolor.black,
                                    height: 1,
                                  ),
                                ),
                                GradientText(
                                  gradient: appcolor.gradient,
                                  widget: Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    blockButton(
                      verticalPadding: 3,
                      width: Get.width * 0.2,
                      callback: () {
                        Get.to(transerFiler(
                          url: 'transactionHistoryFilter',
                          conditon: 2,
                          startDate:
                              '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}',
                          enddate:
                              '${_EndateTime.year}-${_EndateTime.month}-${_EndateTime.day}',
                        ));
                      },
                      widget: Text(
                        AppLocalizations.of(context)!.submit,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Table(border: TableBorder.all(), children: [
                  TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.date,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.amount,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.status,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.points,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ]),
                ]),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data[index];
                        var date = data['created_at'];
                        var splits = date.split('T');
                        var splity = splits[0];
                        var date1 = splity.split('-');
                        // total = int.parse(data['Point']);
                        return Table(border: TableBorder.all(), children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${date1[2]}-${date1[1]}-${date1[0]}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['amount']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['status']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['point']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                              ]),
                          // TableRow(
                          //     children :[
                          //       Text('Date',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //       Text('${data['QR_Code']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //       Text('${data['Reference']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //       Text('${data['Point']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                          //     ]),
                        ]);
                      }),
                )
              ],
            ).paddingSymmetric(
              horizontal: 10,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget Order() {
    return FutureBuilder(
        future: PointHistory('orderhistory'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Data Not Found');
          } else if (snapshot.hasData) {
            // print(snapshot.data[0]['profession']);
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showSearch(
                            context: context, delegate: SearchpageOrder());
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appcolor.newRedColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          width: Get.width * 0.9,
                          height: Get.height * 0.05,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.search),
                                  Icon(
                                    Icons.search,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Total Points ',
                //       style: TextStyle(
                //         fontSize: 14,
                //         height: 1,color: appcolor.redColor
                //       ),
                //     ),
                //     Text(
                //       '${total}',
                //       style: TextStyle(
                //         fontSize: 14,
                //         height: 1,
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(
                //       'Filter :',
                //       style: TextStyle(
                //         fontSize: 16,
                //         height: 1,
                //       ),
                //     ),
                //     Container(
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: appcolor.newRedColor,
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             10,
                //           ),
                //         ),
                //         width: Get.width * 0.26,
                //         height: Get.height * 0.04,
                //         child: Center(
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(
                //                 '${_dateTime == null ? 'Date From: ': '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}'} ',
                //                 style: TextStyle(
                //                   fontSize: 9,
                //                   color: appcolor.black,
                //                   height: 1,
                //                 ),
                //               ),
                //               InkWell(
                //                 onTap: (){
                //                   _datepicker();
                //                 },
                //                 child: GradientText(
                //                   gradient: appcolor.gradient,
                //                   widget: Icon(
                //                     Icons.calendar_month,
                //                     size: 16,
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //         )),
                //     Container(
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: appcolor.newRedColor,
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             10,
                //           ),
                //         ),
                //         width: Get.width * 0.26,
                //         height: Get.height * 0.04,
                //         child: Center(
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(
                //                 '${_EndateTime == DateTime.now() ? 'Date To: ': '${_EndateTime.year}-${_EndateTime.month}-${_EndateTime.day}'}',
                //                 style: TextStyle(
                //                   fontSize: 9,
                //                   color: appcolor.black,
                //                   height: 1,
                //                 ),
                //               ),
                //               InkWell(
                //                 onTap: (){
                //                   _Enddatepicker();
                //                 },
                //                 child: GradientText(
                //                   gradient: appcolor.gradient,
                //                   widget: Icon(
                //                     Icons.calendar_month,
                //                     size: 16,
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //         )),
                //     blockButton(
                //       verticalPadding: 3,
                //       width: Get.width * 0.2,
                //       widget: Text(
                //         'Submit',
                //         style: TextStyle(
                //             color: Colors.white,fontSize: 12
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Table(border: TableBorder.all(), children: [
                  TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.date,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.orderid,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.ordervalue,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.status,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ]),
                ]),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data[index];
                        var date = data['created_at'];

                        var splits = date.split('T');
                        var splity = splits[0];
                        var date1 = splity.split('-');
                        // total = int.parse(data['Point']);

                        return Table(border: TableBorder.all(), children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${date1[2]}-${date1[1]}-${date1[0]}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['order_id']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['total_amount']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['status']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                              ]),
                        ]);
                      }),
                )
              ],
            ).paddingSymmetric(
              horizontal: 10,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
