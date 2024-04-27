import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/CartPage.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/custom_drawer.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/products/view/detailed_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AlertDialogBox/alertBoxContent.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import '../ProductSearch.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ceiling_fan extends StatefulWidget {
  final id;
  const ceiling_fan({super.key, this.id});

  @override
  State<ceiling_fan> createState() => _ceiling_fanState(id);
}

class _ceiling_fanState extends State<ceiling_fan> {
  final id;
  _ceiling_fanState(this.id);
  var checkdata = '';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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
          drawer: customDrawer(
            context,
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: appcolor.gradient,
              ),
            ),
            title: InkWell(
              onTap: () {
                showSearch(context: context, delegate: ProductSearch());
              },
              child: Container(
                height: Get.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                width: Get.width * 0.7,
                child: Center(
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    keyboardType: TextInputType.visiblePassword,
                    cursorHeight: 25,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.search,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        )),
                  ),
                ),
              ),
            ),
            leadingWidth: 35,
            actions: [
              IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var data = prefs.getString('pro');
                  if (data == 'dealer') {
                    Get.to(demo());
                  }
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                ),
                color: Colors.white,
              ),
            ],
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: Banner('allProductByCategory', id),
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
                Column(
                  children: [
                    Container(
                      height: Get.height,
                      child: FutureBuilder(
                          future: GetDataproduct('allProductByCategory', id),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Image.asset('${apiDomain().nodataimage}');
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data.length == 0) {
                                return Text('No Product Found');
                              } else {
                                return GridView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(detailedProductView(
                                          name: data['id'],
                                        ));
                                      },
                                      child: Card(
                                        elevation: 1,
                                        child: Container(
                                          width: Get.width * 0.31,
                                          // height: Get.height * 0.6,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: appcolor.redColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: Get.width,
                                                    height: Get.height * 0.08,
                                                    child: Image.network(
                                                      '${apiDomain().imageUrl + data['image']}',
                                                      fit: BoxFit.contain,
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${data['name'].length < 14 ? data['name'] : data['name']}..',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    //     Column(
                                    //       children: [
                                    //         InkWell(
                                    //           onTap: (){
                                    //             Get.to(ceiling_fan());
                                    //           },
                                    //           child: Container(
                                    //             padding: EdgeInsets.only(
                                    //               bottom: 4,
                                    //             ),
                                    //             child: Image(
                                    //               image: AssetImage(
                                    //                 'assets/image 9.png',
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Text(
                                    //           'Concealed Light\n Box',
                                    //           style: TextStyle(
                                    //             fontSize: 14,
                                    //             height: 1,
                                    //           ),
                                    //           textAlign: TextAlign.center,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     Column(
                                    //       children: [
                                    //         InkWell(
                                    //           onTap: (){
                                    //             Get.to(ceiling_fan());
                                    //           },
                                    //           child: Container(
                                    //             padding: EdgeInsets.only(
                                    //               bottom: 4,
                                    //             ),
                                    //             child: Image(
                                    //               image: AssetImage(
                                    //                 'assets/image 9.png',
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Text(
                                    //           '${data['category']}',
                                    //           style: TextStyle(fontSize: 14, height: 1),
                                    //           textAlign: TextAlign.center,
                                    //         ),
                                    //       ],
                                    //
                                    // ).paddingOnly(
                                    //   bottom: 5,
                                    // );
                                  },
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ),
                    Row(
                      children: [
                        GradientText(
                          gradient: appcolor.gradient,
                          widget: Text(
                            'Ceiling Fan',
                            style: TextStyle(
                                fontSize: 20,
                                height: 1,
                                color: appcolor.redColor),
                          ),
                        ),
                      ],
                    ).paddingOnly(
                      bottom: 10,
                    ),
                    // Wrap(
                    //   spacing: 10,
                    //   runSpacing: 15,
                    //   children: [
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //     appItemWidget('assets/image 25.png'),
                    //
                    //   ],
                    // )
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 10),
              ],
            ),
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  // Widget appItemWidget(
  //   String imagepath,
  // ) {
  //   return InkWell(
  //     onTap: (){
  //       Get.to(detailedProductView());
  //     },
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.only(
  //             bottom: 0,
  //           ),
  //           child: Image(
  //             image: AssetImage(
  //               imagepath,
  //             ),
  //           ),
  //         ),
  //         Container(
  //           child: Text(
  //             'Fan Round Box\n₹128.00 – ₹162.00',
  //             style: TextStyle(
  //               fontSize: 10,
  //               height: 0.9,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         SizedBox(height: 4,),
  //         Container(
  //           padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
  //           decoration: BoxDecoration(
  //               color: appcolor.newRedColor,
  //               borderRadius: BorderRadius.circular(
  //                 8,
  //               )),
  //
  //           child: Text(
  //             'Buy Now',
  //             style: TextStyle(
  //               fontSize: 13,
  //               color: Colors.white,
  //               height: 0.7,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Future GetDataproduct(String url, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var value = {"id": key};

    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //   prefs.setString('electrician', data['profession']);
      print(data);
      checkdata = data['profession'];
      return data['Product'];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  Future Banner(String url, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(key);
    var value = {"id": key};

    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        body: jsonEncode(value),
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
}
