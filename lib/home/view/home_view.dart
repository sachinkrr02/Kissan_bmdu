import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/History/History_view.dart';
import 'package:kisaan_electric/Moddal/cartList.dart';
import 'package:kisaan_electric/auth/login/controller/login_controller.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/custom_drawer.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/QR/view/qr_scanner_view.dart';
import 'package:kisaan_electric/products/view/product_view.dart';
import 'package:kisaan_electric/profile/view/profile_view.dart';
import 'package:kisaan_electric/wallet/view/wallet_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../AssignUserDetail/assign.dart';
import '../../Moddal/urlModal.dart';
import '../../Orders/OrderPage.dart';
import '../../notification/notification_page.dart';
import '../../parnterHistory/PartnerOrder.dart';
import '../../products/view/all_product.dart';
import '../../products/view/detailed_product_view.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home_view extends StatefulWidget {
  const Home_view({super.key});

  @override
  State<Home_view> createState() => _Home_viewState();
}

class _Home_viewState extends State<Home_view> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  login_controller controller = Get.put(login_controller());
  int badge = 0;
  SocialMediaUrl() async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      final response =
          await http.post(Uri.parse('${apiDomain().domain}social_media'),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print(productsData);
        Banners.Items = List.from(productsData)
            .map<Data>((product) => Data.fromJson(product))
            .toList();
        setState(() {});
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  Future HomeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}mainpage'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var daata = data['profession'].toString();
      prefs.setString('pro', daata);
      return data;
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  Future notifcations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response =
        await http.post(Uri.parse('${apiDomain().domain}newnotification'),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('hello${data['data'].length}');
      // setState(() {
      //   badge=data['data'].length;
      // });
      print(data);
      return data;
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  CartListData() async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      final response = await http.post(Uri.parse('${apiDomain().domain}Cart'),
          headers: ({
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        // print(productsData);
        CarList.Items = List.from(productsData)
            .map<CartData>((product) => CartData.fromJson(product))
            .toList();
        setState(() {});
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SocialMediaUrl();
    getConnectivity();
    CartListData();
    notifcations();
  }

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
  var notification_count = 0;
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.areYouSure,
              style: TextStyle(color: Colors.blueGrey),
            ),
            content: Text(
              AppLocalizations.of(context)!.logoutConfirmation,
              style: TextStyle(color: Colors.blueGrey),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appcolor.redColor,
                        shape: BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2)))),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appcolor.redColor,
                        shape: BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2)))),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Container(
        color: Colors.white,
        child: Scaffold(
          drawer: customDrawer(
            context,
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Container(
              width: Get.width * 0.4,
              child: Image(
                image: AssetImage(
                  'assets/plain logo 1.png',
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  _makePhoneCall('+91 8506001015');
                  // Scaffold.of(context).openDrawer();
                },
                child: GradientText(
                  gradient: appcolor.gradient,
                  widget: Icon(
                    Icons.call,
                    color: appcolor.redColor,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Stack(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => notifcation(),
                            ));
                      },
                      child: Icon(
                        Icons.notifications,
                        size: 30,
                        color: appcolor.redColor,
                      )),
                  // Positioned(
                  //            right: 0,
                  //            top: -1,
                  //            child: Container(

                  //              decoration: BoxDecoration(

                  //                shape: BoxShape.circle,
                  //                color: Colors.green,
                  //              ),
                  //              child: Padding(
                  //                padding: const EdgeInsets.all(4.0),
                  //                child: Text(
                  //    "${notification_count<9?notification_count:"9+"}",
                  //  style: TextStyle(color: Colors.white,fontSize: 12),
                  //                ),
                  //              ),
                  //            ),
                  //          ),

                  StreamBuilder(
                      stream: Stream.periodic(Duration(seconds: 5))
                          .asyncMap((i) => notifcations()),
                      // future:ApiDomain().getNotificationCount(),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        if (!snapshot.hasData || snapshot.hasError)
                          return Positioned(
                            right: 1,
                            top: -5,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Text(
                                notification_count.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          );
                        notification_count = snapshot.data['Notifications'];
                        return Positioned(
                          right: 1,
                          top: -5,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Text(
                              "${notification_count < 9 ? notification_count : "9+"}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        );
                      })
                ],
              ),
              SizedBox(
                width: 10,
              )
              // badges.Badge(
              //   showBadge: true,
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>notifcation()));
              //    // Get.to(notifcation());
              //   },
              //   badgeStyle: badges.BadgeStyle(
              //     badgeColor: Colors.blue,
              //     padding: EdgeInsets.all(5),
              //   ),
              //   position: badges.BadgePosition.topEnd(top: -2, end: 5),
              //   badgeContent: Text('${badge <=9 ?badge :'9+'}',style: TextStyle(color: Colors.white),),
              //   child: IconButton(
              //     onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>notifcation()));
              //      // Get.to(notifcation());
              //     },
              //     icon: Icon(
              //       Icons.notifications,color: appcolor.redColor,
              //     ),
              //   ),
              // )
            ],
            leading: Builder(
              builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: GradientText(
                    gradient: appcolor.gradient,
                    widget: Icon(
                      Icons.sort,
                      color: appcolor.redColor,
                    ),
                  ),
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(color: Colors.white),
                child: FutureBuilder(
                  future: HomeData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Image.asset('assets/img_15.png'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.hello} ${data['name']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: appcolor.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.status,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: appcolor.black,
                                    ),
                                  ),
                                  Text(
                                    '${data['user_status']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: data['user_status'] == 'Approved'
                                          ? Colors.green
                                          : Colors.yellow,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 18),
                          data['profession'].toString() == 'partner'
                              ? Expanded(
                                  child: Container(
                                      child: FutureBuilder(
                                    future: api().GetData('orderPartner', ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Image.asset(
                                              '${apiDomain().nodataimage}'),
                                        );
                                      } else if (snapshot.hasData) {
                                        return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              var data = snapshot.data[index];
                                              var date =
                                                  data['created_at'].split('T');
                                              var date1 = date[0].split('-');
                                              return Card(
                                                child: ListTile(
                                                  onTap: () {
                                                    Get.off(Demos(
                                                      orderid: data['order_id'],
                                                      orderstatus:
                                                          data['status'],
                                                    ));
                                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderDetailPartner(orderid: data['order_id'],orderstatus: data['status'],)));
                                                  },
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('${data['name']}'),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .qty,
                                                            style: TextStyle(
                                                                color: appcolor
                                                                    .redColor),
                                                          ),
                                                          Text(
                                                            " : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          Text(
                                                              '${data['quantity']}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Rs. ${data['total_amount']}'),
                                                          Text(
                                                              '${data['order_id']}')
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(AppLocalizations
                                                                      .of(context)!
                                                                  .date),
                                                              Text(
                                                                " : ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                ' ${date1[2]}-${date1[1]}-${date1[0]}',
                                                                style: TextStyle(
                                                                    color: data['status'] == 'pending'
                                                                        ? Colors.blueAccent
                                                                        : data['status'] == 'success'
                                                                            ? Colors.green
                                                                            : appcolor.redColor),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(AppLocalizations
                                                                      .of(context)!
                                                                  .status),
                                                              Text(
                                                                " : ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                ' ${data['status']}',
                                                                style: TextStyle(
                                                                    color: data['status'] == 'pending'
                                                                        ? Colors.blueAccent
                                                                        : data['status'] == 'success'
                                                                            ? Colors.green
                                                                            : appcolor.redColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  )),
                                )
                              : Column(
                                  children: [
                                    CarouselSlider.builder(
                                        itemCount: data['banner'].length,
                                        itemBuilder:
                                            (context, index, realindex) {
                                          final urlimage =
                                              data['banner'][index];
                                          return Container(
                                            width: Get.width,
                                            color: Colors.grey,
                                            child: Image.network(
                                              apiDomain().imageUrl +
                                                  urlimage['banner'],
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                            autoPlay: true,
                                            height: Get.height * 0.12,
                                            enlargeCenterPage: false,
                                            aspectRatio: 2.0,
                                            viewportFraction: 1.0,
                                            initialPage: 0,
                                            onPageChanged: (index, reason) {})),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Card(
                                              elevation: 1,
                                              child: Container(
                                                width: Get.width * 0.4,
                                                height: Get.height * 0.11,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffEEEEEE),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8,
                                                  ),
                                                  // border: Border.all(color: Color(0xff3C2B99)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    GradientText(
                                                      gradient:
                                                          appcolor.gradient,
                                                      widget: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .yourPoints,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    GradientText(
                                                      gradient:
                                                          appcolor.gradient,
                                                      widget: Text(
                                                        '${data['total_point']} Pts.',
                                                        style: TextStyle(
                                                            fontSize: 27,
                                                            color: appcolor
                                                                .redColor),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 1,
                                              child: Container(
                                                width: Get.width * 0.4,
                                                height: Get.height * 0.11,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffEEEEEE),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8,
                                                  ),
                                                  //   border: Border.all(color: Color(0xff3C2B99)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GradientText(
                                                      gradient:
                                                          appcolor.gradient,
                                                      widget: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .totalRedemptions,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Text(
                                                      "(${AppLocalizations.of(context)!.financialYear})",
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    GradientText(
                                                      gradient:
                                                          appcolor.gradient,
                                                      widget: Text(
                                                        'Rs.${data['redeem']}',
                                                        style: TextStyle(
                                                            fontSize: 27,
                                                            color: appcolor
                                                                .redColor),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).paddingOnly(
                                          bottom: 20,
                                        ),
                                        Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          spacing: 5,
                                          runSpacing: 10,
                                          children: [
                                            customwidget(
                                              assetimagepath:
                                                  'assets/scan 1.png',
                                              callback: () {
                                                Get.to(qr_scanner_view(
                                                  data: data,
                                                ));
                                              },
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .scan,
                                            ),
                                            customwidget(
                                              assetimagepath:
                                                  'assets/Vector (1).png',
                                              callback: () {
                                                Get.to(wallet_view());
                                              },
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .myWallet,
                                            ),
                                            customwidget(
                                              assetimagepath:
                                                  'assets/Vector.png',
                                              callback: () {
                                                Get.offAll(profile_view());
                                              },
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .myProfile,
                                            ),
                                            customwidget(
                                              assetimagepath:
                                                  'assets/history ico.png',
                                              callback: () {
                                                Get.to(historyView(
                                                  condition: data,
                                                ));
                                              },
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .history,
                                            ),
                                            customwidget(
                                              assetimagepath:
                                                  'assets/product2.png',
                                              callback: () {
                                                data['user_status'] == 'Pending'
                                                    ? alertBoxdialogBox(
                                                        context,
                                                        'Alert',
                                                        'Status: ${data['user_status']}')
                                                    : Get.to(product_view());
                                              },
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .ourProducts,
                                            ),
                                            data['profession'].toString() ==
                                                    'dealer'
                                                ? customwidget(
                                                    assetimagepath:
                                                        'assets/Vector (16).png',
                                                    callback: () {
                                                      Get.to(OrderPage());
                                                    },
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .orders,
                                                  )
                                                : customwidget(
                                                    assetimagepath:
                                                        'assets/img_16.png',
                                                    callback: () {
                                                      Get.to(assign());
                                                    },
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .assign,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GradientText(
                                          gradient: appcolor.gradient,
                                          widget: Text(
                                            AppLocalizations.of(context)!
                                                .ourProducts,
                                            style: TextStyle(
                                                fontSize: 20,
                                                height: 1,
                                                color: appcolor.redColor),
                                          ),
                                        ).paddingSymmetric(
                                          vertical: 6,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Wrap(
                                                spacing: 8,
                                                children: <Widget>[
                                                  Container(
                                                    height: Get.height * 0.1,
                                                    child: FutureBuilder(
                                                        future: api().GetData(
                                                            'allProduct', ''),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Data not Fount');
                                                          } else if (snapshot
                                                              .hasData) {
                                                            if (snapshot.data
                                                                    .length ==
                                                                0) {
                                                              return Text(
                                                                  'No Product Found');
                                                            } else {
                                                              return ListView
                                                                  .builder(
                                                                      itemCount: snapshot
                                                                          .data
                                                                          .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        var dataa =
                                                                            snapshot.data[index];
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (data['user_status'] ==
                                                                                'Approved') {
                                                                              Get.to(detailedProductView(
                                                                                name: dataa['id'],
                                                                              ));
                                                                            }
                                                                          },
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                1,
                                                                            child:
                                                                                Container(
                                                                              width: Get.width * 0.25,
                                                                              height: Get.height * 0.2,
                                                                              decoration: BoxDecoration(border: Border.all(color: appcolor.redColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(2.0),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: Get.width,
                                                                                        height: Get.height * 0.04,
                                                                                        child: Image.network(
                                                                                          '${apiDomain().imageUrl + dataa['image']}',
                                                                                          fit: BoxFit.contain,
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    Text(
                                                                                      '${dataa['name'].length < 10 ? dataa['name'] : '${dataa['name'].toString().substring(0, 10)}..'}',
                                                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                      maxLines: 2,
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
                                                bottom: 10,
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
                                              "See More",
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
                                    ).paddingSymmetric(
                                      horizontal: 18,
                                      vertical: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Container(
                                        height: Get.height * 0.08,
                                        width: Get.width,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Banners.Items != null &&
                                                    Banners.Items.isNotEmpty
                                                ? ListView.builder(
                                                    itemCount:
                                                        Banners.Items.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final url =
                                                          Banners.Items[index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SocialMedia(
                                                              assetimagepath:
                                                                  'assets/inst.png',
                                                              callback: () {
                                                                var urls = url
                                                                    .instagram
                                                                    .toString();
                                                                _launchInBrowserView(
                                                                    urls);
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            SocialMedia(
                                                              assetimagepath:
                                                                  'assets/youtbe.png',
                                                              callback: () {
                                                                var urls = url
                                                                    .youtube
                                                                    .toString();
                                                                _launchInBrowserView(
                                                                    urls);
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            SocialMedia(
                                                              assetimagepath:
                                                                  'assets/fb.png',
                                                              callback: () {
                                                                var urls = url
                                                                    .facebook
                                                                    .toString();
                                                                _launchInBrowserView(
                                                                    urls);
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            SocialMedia(
                                                              assetimagepath:
                                                                  'assets/img_9.png',
                                                              callback: () {
                                                                var urls = url
                                                                    .linkedin
                                                                    .toString();
                                                                _launchInBrowserView(
                                                                    urls);
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            SocialMedia(
                                                              assetimagepath:
                                                                  'assets/img_13.png',
                                                              callback: () {
                                                                var urls = url
                                                                    .twitter
                                                                    .toString();
                                                                _launchInBrowserView(
                                                                    urls);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )),
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowserView(url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}

Widget customwidget({
  Function()? callback,
  String? assetimagepath,
  String? title,
}) {
  return InkWell(
    onTap: callback,
    child: Column(
      children: [
        Container(
          child: PhysicalShape(
            elevation: 1,
            clipper: ShapeBorderClipper(shape: CircleBorder()),
            color: Color(0xffEEEEEE),
            child: Container(
                height: 70,
                width: 100,
                child: Image.asset(
                  assetimagepath.toString(),
                )),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GradientText(
          widget: Text(
            '$title',
            style: TextStyle(
              fontSize: 14,
              color: appcolor.redColor,
            ),
          ),
          gradient: appcolor.gradient,
        ),
      ],
    ),
  );
}

Widget SocialMedia({
  Function()? callback,
  String? assetimagepath,
}) {
  return InkWell(
    onTap: callback,
    child: Column(
      children: [
        CircleAvatar(
            radius: 22,
            backgroundColor: appcolor.greyColor,
            child: Center(
                child: Image.asset(
              assetimagepath.toString(),
              height: 20,
              width: 20,
            ))),
      ],
    ),
  );
}
