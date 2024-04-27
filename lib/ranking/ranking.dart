import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AlertDialogBox/alertBoxContent.dart';
import '../products/controller/product_controller.dart';
import '../server/apiDomain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ranking extends StatefulWidget {
  const ranking({super.key});

  @override
  State<ranking> createState() => _rankingState();
}

class _rankingState extends State<ranking> {
  productController controller = Get.put(productController());
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

  Future Banner(
    String url,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == false) {
        return AlertBoxdialogBoxes(context, 'Alert', '${data['massage']}');
      }
      //   prefs.setString('electrician', data['profession']);
      return data['banner'];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              customAppBar('${AppLocalizations.of(context)!.ranking}', ''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              FutureBuilder(
                  future: Banner(
                    'ranking',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('');
                    } else if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Text('No Banner Found');
                      } else {
                        return CarouselSlider.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index, realindex) {
                              final urlimage = snapshot.data[index];
                              return Container(
                                  height: 120,
                                  width: Get.width,
                                  child: Image.network(
                                    '${apiDomain().imageUrl + urlimage['banner']}',
                                    fit: BoxFit.cover,
                                  ));
                            },
                            options: CarouselOptions(
                                autoPlay: false,
                                height: 120,
                                enlargeCenterPage: false,
                                aspectRatio: 2.0,
                                viewportFraction: 1.0,
                                initialPage: 0,
                                onPageChanged: (index, reason) {}));
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              Expanded(child: Transition())
              // Container(
              //   decoration: BoxDecoration(),
              //   height: Get.height * 0.08,
              //
              //   child:
              //   Expanded(child: ),
              // //   TabBar(
              // //     dividerColor: appcolor.newRedColor,
              // //     unselectedLabelColor: Colors.black,
              // //     unselectedLabelStyle: TextStyle(
              // //       fontSize: 16,
              // //     ),
              // //     indicatorColor: appcolor.redColor,
              // //     labelColor: Colors.black,
              // //     labelStyle: TextStyle(
              // //       fontWeight: FontWeight.bold,
              // //       color: Colors.black,
              // //       fontSize: 18,
              // //     ),
              // //     controller: controller.tabcontroller,
              // //     tabs: [
              // //       Container(
              // //         child: Text(
              // //           'Electrician'.tr,
              // //         ),
              // //       ),
              // //       Container(
              // //         child: Text('Partner'.tr),
              // //       ),
              // //       Text('Dealer'.tr),
              // //     ],
              // //   ),
              // // ),
              // // Expanded(
              // //   child:
              // //       TabBarView(controller: controller.tabcontroller, children: [
              // //     Transition(),
              // //     Transition(),
              // //     Transition(),
              // //   ]),
              // // )
              // )
            ],
          ),
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
      print(data);
      return data['data'];
    }
  }

  Widget Transition() {
    DateTime dateTime = DateTime.now();
    return FutureBuilder(
        future: PointHistory('ranking'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Data Not Found');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Table(border: TableBorder.all(), children: [
                  TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.ranking,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.code,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.name,
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
                        return Table(border: TableBorder.all(), children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${index + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${data['cin_no'] == null ? '' : data['cin_no']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${data['name'] == null ? '' : data['name']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data['total_Point']}',
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
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: (){
    //        Get.back();
    //       },
    //       icon: Icon(Icons.navigate_before,color: appcolor.redColor,size: 35,)),
    //     automaticallyImplyLeading: false,
    //     title: Text("Ranking",style: TextStyle(color: appcolor.redColor,fontWeight: FontWeight.bold,fontSize: 20),),
    //   ),
    //  body: Column(
    //   children: [
    //      Container(
    //       color: Colors.black,
    //       width: Get.width,
    //       height: 1,
    //      ),
    //      SizedBox(
    //       height: Get.height*0.05,
    //      ),
    //      Text("Coming Soon",style: TextStyle(fontSize: 20),)
    //   ],
    //  ),
    // );
  }
}
