import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/CartPage.dart';
import 'package:http/http.dart' as http;
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/custom_drawer.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import '../ProductSearch.dart';
import 'detailed_product_view.dart';

class ecoSeries_view extends StatefulWidget {
  final id;
  final name;
  const ecoSeries_view({super.key, this.id, this.name});

  @override
  State<ecoSeries_view> createState() => _ecoSeries_viewState(id, name);
}

class _ecoSeries_viewState extends State<ecoSeries_view> {
  final id;
  final name;
  _ecoSeries_viewState(this.id, this.name);
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
                        hintText: 'Search',
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
                    future: Banner('allProductBySeries', id),
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
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: GetDataproduct('allProductBySeries', id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Image.asset('${apiDomain().nodataimage}'));
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
                                    width: Get.width * 0.3,
                                    // height: Get.height * 0.6,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: appcolor.redColor, width: 1),
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
                                            '${data['name'].length < 14 ? data['name'] : '${data['name'].toString()}'}..',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
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
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  Future GetDataproduct(String url, key) async {
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
