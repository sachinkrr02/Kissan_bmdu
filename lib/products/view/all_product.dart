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
import 'package:kisaan_electric/whatsaapIcon/WhatsaapIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../server/apiDomain.dart';
import '../ProductSearch.dart';
import 'detailed_product_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class allProduct extends StatefulWidget {
  const allProduct({super.key});

  @override
  State<allProduct> createState() => _allProduct();
}

class _allProduct extends State<allProduct> {
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

  var checkdata = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white),
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
                      Get.to(CartPage());
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: 50,),
                  // Center(child: Text('Coming Soon',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),))

                  FutureBuilder(
                      future: api().Banner('allProduct', ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('');
                        } else if (snapshot.hasData) {
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
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  Column(
                    children: [
                      Row(
                        children: [
                          GradientText(
                            gradient: appcolor.gradient,
                            widget: Text(
                              AppLocalizations.of(context)!.allproducts,
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: Get.height,
                        child: FutureBuilder(
                            future: GetAllProduct('allProduct'),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Data Not Found');
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData) {
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
                                          width: Get.width * 0.3,
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
                                                    height: Get.height * 0.09,
                                                    child: Image.network(
                                                      '${apiDomain().imageUrl + data['image']}',
                                                      fit: BoxFit.contain,
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${data['name'].length < 14 ? data['name'] : '${data['name'].toString().substring(0, 14)}..'}',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ),
                      // Wrap(
                      //   spacing: 10,
                      //   runSpacing: 15,
                      //   children: [
                      //     appItemWidget(),
                      //     appItemWidget(),
                      //     appItemWidget(),
                      //     appItemWidget(),
                      //     appItemWidget(),
                      //     appItemWidget(),
                      //   ],
                      // )
                    ],
                  ).paddingSymmetric(horizontal: 10, vertical: 10),
                ],
              ),
            ),
            floatingActionButton: floatingActionButon(context)),
      ),
    );
  }

  Future GetAllProduct(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      checkdata = data['profession'];
      print(checkdata);
      return data['data'];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
