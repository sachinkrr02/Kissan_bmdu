import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/Orders/OrderPage.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:http/http.dart' as http;
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AlertDialogBox/alertBoxContent.dart';
import 'Moddal/cartList.dart';
import 'global/blockButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int quantity = 0;
  var image = 'assets/image 16.png';
  var Name = 'Double Door';
  var Price;
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
        print(productsData);
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

  Future Updatedata(String url, Object value, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OrderPage()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data['message']}')));
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
      return data[0];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotal();
    CartListData();
    getConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [],
          color: Colors.grey[200],
        ),
        height: Get.height * 0.11,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalRedemptions,
                        style: TextStyle(
                            color: appcolor.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppLocalizations.of(context)!.amount,
                        style: TextStyle(
                            color: appcolor.redColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  blockButton(
                      width: Get.width * 0.3,
                      widget: Text(
                        AppLocalizations.of(context)!.check,
                        style: TextStyle(color: Colors.white),
                      ),
                      callback: () {
                        var value = {"amount": Price.toString()};
                        if (Price == 0.0) {
                          alertBoxdialogBox(
                              context, 'Alert', 'No Product Found');
                        } else {
                          Updatedata('order', value, context);
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffEEEEEE),
        title: Text(
          AppLocalizations.of(context)!.card,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            )),
      ),
      body: CarList.Items.isNotEmpty && CarList.Items != null
          ? ListView.builder(
              itemCount: CarList.Items.length,
              itemBuilder: (context, index) {
                var data = CarList.Items[index];
                var totalCost = double.parse(data.price.toString()) *
                    double.parse(data.quantity.toString());
                return Card(
                  elevation: 4,
                  color: Color(0xffEEEEEE),
                  child: ListTile(
                    leading: Container(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          '${apiDomain().imageUrl + data.image.toString()}',
                          fit: BoxFit.cover,
                        )),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Get.height * 0.03,
                          width: Get.width * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: appcolor.redColor,
                                  height: 0.9,
                                ),
                              ),
                              Container(
                                height: Get.height * 0.03,
                                width: Get.width * 0.35,
                                child: Text(
                                  data.productName.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 0.9,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              var value = {"id": data.id, 'type': 'delete'};
                              Updated('Cart', value, context, 1);
                              CarList.Items.remove(data);
                              setState(() {
                                getTotal();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.amount,
                              style: TextStyle(
                                fontSize: 14,
                                color: appcolor.redColor,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              '${totalCost}',
                              style: TextStyle(
                                fontSize: 14,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set your desired background color
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (data.quantity != '1') {
                                        if (data.quantity! <= 1) {
                                        } else {
                                          data.quantity = (int.parse(
                                                  data.quantity.toString()) -
                                              1);
                                          getTotal();
                                          var value = {
                                            "id": data.id,
                                            "quantity": data.quantity
                                          };
                                          Update(value);
                                        }
                                      }
                                    });
                                  },
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                      )),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${int.parse(data.quantity.toString())}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      data.quantity =
                                          (int.parse(data.quantity.toString()) +
                                              1);
                                      getTotal();
                                      var value = {
                                        "id": data.id,
                                        "quantity": data.quantity
                                      };
                                      Update(value);
                                    });
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Image.asset(apiDomain().nodataimage.toString()),
            ),
    );
  }

  double getTotal() {
    double total = 0.0;
    setState(() {
      CarList.Items.forEach((element) {
        total += (int.parse(element.price.toString()))! *
            (int.parse(element.quantity.toString()));
      });
    });
    setState(() {
      Price = double.parse('$total');
    });
    return total;
  }

  Future Update(Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response =
        await http.post(Uri.parse('${apiDomain().domain}updateQuantity'),
            body: jsonEncode(value),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    print(response.statusCode);
    if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }

  Future Updated(String url, Object value, context, int check) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(value);
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
      //print(data['message']);
      if (data['status'] == true) {
        if (check == 1) {
          alertBoxdialogBox(context, 'Alert', '${data['message']}');
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              getTotal();
              CartListData();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            });
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data['message']}')));
        }
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
      return data[0];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
