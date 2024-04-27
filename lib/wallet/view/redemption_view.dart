import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/wallet/controller/wallte_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../History/schemeFilter.dart';
import '../../History/tansitonFilter.dart';
import '../../global/gradient_text.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class redemption_view extends StatefulWidget {
  const redemption_view({super.key});

  @override
  State<redemption_view> createState() => _redemption_viewState();
}

class _redemption_viewState extends State<redemption_view> {
  wallet_controller controller = Get.put(wallet_controller());
  DateTime _dateTime = DateTime.now();
  DateTime _EndateTime = DateTime.now();
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
            //   image: DecorationImage(
            //       image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
            ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              //  customAppBar('Redemption History',''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              Expanded(child: Transition())

              // Container(
              //   decoration: BoxDecoration(),
              //   height: Get.height * 0.08,
              //   child: TabBar(
              //     dividerColor: appcolor.newRedColor,
              //     isScrollable: true,
              //     unselectedLabelColor: Colors.black,
              //     unselectedLabelStyle: TextStyle(
              //       fontSize: 16,
              //     ),
              //     indicatorColor: appcolor.redColor,
              //     labelColor: Colors.black,
              //     labelStyle: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black,
              //       fontSize: 16,
              //     ),
              //     controller: controller.tabcontroller,
              //     tabs: [
              //       Container(
              //         child: Text(
              //           'All'.tr,
              //         ),
              //       ),
              //       Container(
              //         child: Text('Pending'.tr),
              //       ),
              //       Text('Success'.tr),
              //       Text('Failed'.tr),
              //     ],
              //   ),
              // ),
              // Expanded(
              //     child: TabBarView(
              //   controller: controller.tabcontroller,
              //   children: [
              //     Container(
              //       child: Center(
              //           child: Text(
              //         'There are no transaction available',
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       )),
              //     ),
              //     Container(
              //       child: Center(
              //           child: Text(
              //         'There are no transaction available',
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       )),
              //     ),
              //     Container(
              //       child: Center(
              //           child: Text(
              //         'There are no transaction available',
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       )),
              //     ),
              //     Container(
              //       child: Center(
              //           child: Text(
              //         'There are no transaction available',
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       )),
              //     ),
              //   ],
              // ))
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

  Widget Transition() {
    return FutureBuilder(
        future: PointHistory('schemeHistory'),
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
                        Get.to(schemeFilter(
                          url: 'schemehistoryFilter',
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
                          child: Text(AppLocalizations.of(context)!.scheme,
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
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['scheme_name']}',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['status']}',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['point']}',
                                      style: TextStyle(
                                        fontSize: 10,
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
}
