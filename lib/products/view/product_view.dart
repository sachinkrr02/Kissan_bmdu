import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/CartPage.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/custom_drawer.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/products/view/all_categories.dart';
import 'package:kisaan_electric/products/view/all_product.dart';
import 'package:kisaan_electric/products/view/ceilingfan_view.dart';
import 'package:kisaan_electric/products/view/eco_series_view.dart';
import 'package:kisaan_electric/whatsaapIcon/WhatsaapIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../AlertDialogBox/alertBoxContent.dart';
import '../../server/apiDomain.dart';
import '../ProductSearch.dart';
import 'detailed_product_view.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class product_view extends StatefulWidget {
  const product_view({super.key});

  @override
  State<product_view> createState() => _product_viewState();
}

class _product_viewState extends State<product_view> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  List indicator = [];
  var indexs;
  int _current = 0;
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
                      cursorHeight: 24,
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
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: 50,),
                  // Center(child: Text('Coming Soon',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),))
                  FutureBuilder(
                      future: Banner('productBanner', ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('');
                        } else if (snapshot.hasData) {
                          if (snapshot.data.length == 0) {
                            return Text('No Image Found');
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
                      Row(
                        children: [
                          GradientText(
                            gradient: appcolor.gradient,
                            widget: Text(
                              AppLocalizations.of(context)!.allseries,
                              style: TextStyle(
                                  fontSize: 20,
                                  height: 1,
                                  color: appcolor.redColor),
                            ),
                          ),
                        ],
                      ).paddingOnly(
                        bottom: 5,
                      ),
                      Container(
                        height: Get.height * 0.2,
                        child: FutureBuilder(
                            future: api().GetData('allSeries', ''),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Image.asset(
                                    '${apiDomain().nodataimage}');
                              } else if (snapshot.hasData) {
                                if (snapshot.data.length == 0) {
                                  return Text('No Series Found');
                                } else {
                                  return Column(children: [
                                    CarouselSlider.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (context, index, realindex) {
                                          final data = snapshot.data[index];
                                          return InkWell(
                                            onTap: () {
                                              Get.to(ecoSeries_view(
                                                id: data['id'],
                                                name: data['name'],
                                              ));
                                            },
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        CircleAvatar(
                                                          radius: 42,
                                                          backgroundColor:
                                                              appcolor.redColor,
                                                          child: CircleAvatar(
                                                            radius: 40,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              '${apiDomain().imageUrl + data['image']}',
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${data['Series']}',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).paddingOnly(
                                            bottom: 7,
                                          );
                                        },
                                        options: CarouselOptions(
                                            autoPlay: false,
                                            height: Get.height * 0.16,
                                            enlargeCenterPage: false,
                                            aspectRatio: 3.0,
                                            viewportFraction: 1 / 2.98,
                                            initialPage: 0,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _current = index;
                                              });
                                            })),
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AnimatedSmoothIndicator(
                                          activeIndex: _current,
                                          count: snapshot.data.length,
                                          effect: JumpingDotEffect(
                                              dotWidth: 8,
                                              dotHeight: 8,
                                              activeDotColor: Colors.red,
                                              dotColor: Colors.black12),
                                        ),
                                      ),
                                    ),
                                  ]);
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
                          InkWell(
                            onTap: () {
                              // Get.to(ecoSeries_view());
                            },
                            child: GradientText(
                              gradient: appcolor.gradient,
                              widget: Text(
                                AppLocalizations.of(context)!.allcategories,
                                style: TextStyle(
                                    fontSize: 20,
                                    height: 1,
                                    color: appcolor.redColor),
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(
                        bottom: 10,
                      ),

                      // All category data fetch
                      Container(
                        height: 125,
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
                                      itemCount: 3,
                                      // snapshot.data.length,
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        height:
                                                            Get.height * 0.09,
                                                        width: Get.width,
                                                        padding:
                                                            EdgeInsets.only(
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
                                                              FontWeight.bold),
                                                      maxLines: 2,
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
                      ),
                      Container(
                        height: Get.height * 0.055,
                        child: blockButton(
                          callback: () {
                            Get.to(allCategories());
                          },
                          width: Get.width * 0.3,
                          widget: Text(
                            AppLocalizations.of(context)!.seeMore,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                          ),
                          verticalPadding: 3,
                        ),
                      ),
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
                            bottom: 7,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Wrap(
                                  spacing: 8,
                                  children: <Widget>[
                                    Container(
                                      height: 125,
                                      child: FutureBuilder(
                                          future:
                                              api().GetData('allProduct', ''),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Data not Fount');
                                            } else if (snapshot.hasData) {
                                              if (snapshot.data.length == 0) {
                                                return Text('No Product Found');
                                              } else {
                                                return ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var data =
                                                          snapshot.data[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          Get.to(
                                                              detailedProductView(
                                                            name: data['id'],
                                                          ));
                                                        },
                                                        child: Card(
                                                          elevation: 1,
                                                          child: Container(
                                                            width:
                                                                Get.width * 0.3,
                                                            height: Get.height *
                                                                0.2,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    width: 1),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                      width: Get
                                                                          .width,
                                                                      height: Get
                                                                              .height *
                                                                          0.09,
                                                                      child: Image
                                                                          .network(
                                                                        '${apiDomain().imageUrl + data['image']}',
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    '${data['name'].length < 14 ? data['name'] : '${data['name'].toString().substring(0, 14)}..'}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
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
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          }),
                                    )

                                    // InkWell(
                                    //   onTap: (){
                                    //     Get.to(allProduct());
                                    //   },
                                    //   child: Card(elevation: 1,
                                    //     child: Container(
                                    //       width: Get.width * 0.28,
                                    //       height: Get.height * 0.11,
                                    //       decoration: BoxDecoration(
                                    //         color: Color(0xffEEEEEE),
                                    //         borderRadius: BorderRadius.circular(
                                    //           8,
                                    //         ),
                                    //         //   border: Border.all(color: Color(0xff3C2B99)),
                                    //       ),
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //         children: [
                                    //           Container(
                                    //             height: Get.height * 0.06,
                                    //             child: Image(
                                    //                 image: AssetImage('assets/image1 1.png')),
                                    //           ),
                                    //           Text(
                                    //             'CONCEALED BOX',
                                    //             style: TextStyle(
                                    //               fontSize: 10,
                                    //             ),
                                    //             textAlign: TextAlign.center,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // InkWell(
                                    //   onTap: (){
                                    //     Get.to(allProduct());
                                    //   },
                                    //   child: Card(
                                    //     elevation: 1,
                                    //     child: Container(
                                    //       width: Get.width * 0.28,
                                    //       height: Get.height * 0.11,
                                    //       decoration: BoxDecoration(
                                    //         color: Color(0xffEEEEEE),
                                    //         borderRadius: BorderRadius.circular(
                                    //           8,
                                    //         ),
                                    //         // border: Border.all(color: Color(0xff3C2B99)),
                                    //       ),
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //         children: [
                                    //           Container(
                                    //             height: Get.height * 0.06,
                                    //             child: Image(
                                    //                 image: AssetImage('assets/image 4.png')),
                                    //           ),
                                    //           Text(
                                    //             'FAN BOXS',
                                    //             style: TextStyle(
                                    //               fontSize: 10,
                                    //             ),
                                    //             textAlign: TextAlign.center,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // InkWell(
                                    //   onTap: (){
                                    //     Get.to(allProduct());
                                    //   },
                                    //   child: Card(elevation: 1,
                                    //     child: Container(
                                    //       width: Get.width * 0.28,
                                    //       height: Get.height * 0.11,
                                    //       decoration: BoxDecoration(
                                    //         color: Color(0xffEEEEEE),
                                    //         borderRadius: BorderRadius.circular(
                                    //           8,
                                    //         ),
                                    //         //  border: Border.all(color: Color(0xff3C2B99)),
                                    //       ),
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //         children: [
                                    //           Container(
                                    //             height: Get.height * 0.06,
                                    //             child: Image(
                                    //                 image: AssetImage('assets/image1 1.png')),
                                    //           ),
                                    //           Text(
                                    //             'CONCEALED BOX',
                                    //             style: TextStyle(
                                    //               fontSize: 10,
                                    //             ),
                                    //             textAlign: TextAlign.center,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // InkWell(
                                    //   onTap: (){
                                    //     Get.to(allProduct());
                                    //   },
                                    //   child: Card(
                                    //     elevation: 1,
                                    //     child: Container(
                                    //       width: Get.width * 0.28,
                                    //       height: Get.height * 0.11,
                                    //       decoration: BoxDecoration(
                                    //         color: Color(0xffEEEEEE),
                                    //         borderRadius: BorderRadius.circular(
                                    //           8,
                                    //         ),
                                    //         //    border: Border.all(color: Color(0xff3C2B99)),
                                    //       ),
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //         children: [
                                    //           Container(
                                    //             height: Get.height * 0.06,
                                    //             child: Image(
                                    //                 image: AssetImage('assets/image 4.png')),
                                    //           ),
                                    //           Text(
                                    //             'FAN BOXS',
                                    //             style: TextStyle(
                                    //               fontSize: 10,
                                    //             ),
                                    //             textAlign: TextAlign.center,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ).paddingOnly(
                                  bottom: 5,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: Get.height * 0.055,
                            child: blockButton(
                              callback: () {
                                Get.to(allProduct());
                              },
                              width: Get.width * 0.3,
                              widget: Text(
                                AppLocalizations.of(context)!.seeMore,
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
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10, vertical: 10),
                ],
              ),
            ),
            floatingActionButton: floatingActionButon(context)),
      ),
    );
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
