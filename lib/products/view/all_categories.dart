import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/CartPage.dart';
import 'package:kisaan_electric/global/custom_drawer.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/products/ProductSearch.dart';
import 'package:kisaan_electric/products/view/ceilingfan_view.dart';
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:kisaan_electric/whatsaapIcon/WhatsaapIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class allCategories extends StatefulWidget {
  const allCategories({super.key});

  @override
  State<allCategories> createState() => _allCategoriesState();
}

class _allCategoriesState extends State<allCategories> {
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
          drawer: customDrawer(context),
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

                // FutureBuilder(
                //     future: api().Banner('allProduct', ''),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasError) {
                //         return Text('');
                //       } else if (snapshot.hasData) {
                //         return CarouselSlider.builder(
                //             itemCount: snapshot.data.length,
                //             itemBuilder: (context, index, realindex) {
                //               final urlimage = snapshot.data[index];
                //               return Container(
                //                   height: 120,
                //                   width: Get.width,
                //                   child: Image.network(
                //                     '${apiDomain().imageUrl + urlimage['banner']}',
                //                     fit: BoxFit.cover,
                //                   ));
                //             },
                //             options: CarouselOptions(
                //                 autoPlay: false,
                //                 height: 120,
                //                 enlargeCenterPage: false,
                //                 aspectRatio: 2.0,
                //                 viewportFraction: 1.0,
                //                 initialPage: 0,
                //                 onPageChanged: (index, reason) {}));
                //       } else {
                //         return Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       }
                //     }),
                Column(
                  children: [
                    Row(
                      children: [
                        GradientText(
                          gradient: appcolor.gradient,
                          widget: Text(
                            AppLocalizations.of(context)!.allcategories,
                            style: TextStyle(
                                fontSize: 20,
                                height: 1,
                                color: appcolor.redColor),
                          ),
                        ),
                      ],
                    ).paddingOnly(
                      bottom: 8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder(
                          future: api().GetData('allCategory', ''),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Data Not Found');
                            } else if (snapshot.hasData) {
                              if (snapshot.data.length == 0) {
                                return Text('No Category Found');
                              } else {
                                return GridView.builder(
                                    physics: ScrollPhysics(),
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
                                          Get.to(ceiling_fan(
                                            id: data['id'],
                                          ));
                                        },
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: appcolor.redColor,
                                                    width: 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: Get.height * 0.09,
                                                      width: Get.width,
                                                      padding: EdgeInsets.only(
                                                        bottom: 4,
                                                      ),
                                                      child: Image.network(
                                                        '${apiDomain().imageUrl + data['image']}',
                                                        fit: BoxFit.contain,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${data['category'].length < 14 ? data['category'] : data['category'].toString().substring(0, 14) + '..'}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ), // Wrap(
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
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }
}
