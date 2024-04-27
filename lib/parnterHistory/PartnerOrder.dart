import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:http/http.dart' as http;
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AlertDialogBox/alertBoxContent.dart';
import '../Moddal/OrderDetailPartner.dart';
import '../global/blockButton.dart';
import '../home/view/home_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Demos extends StatefulWidget {
  final orderid;
  final orderstatus;
  const Demos({super.key, this.orderid, this.orderstatus});

  @override
  State<Demos> createState() => _DemosState(orderid, orderstatus);
}

class _DemosState extends State<Demos> {
  final orderid;
  final orderstatus;
  _DemosState(this.orderid, this.orderstatus);

  Future getaddress(String Orderid) async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(Orderid);
    var value = {"order_id": Orderid};
    try {
      final response =
          await http.post(Uri.parse('${apiDomain().domain}deatilbyUser'),
              body: jsonEncode(value),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["userData"];
        print('sdasdff$productsData');

        return productsData;
        // getaddresspartner.Items = List.from(productsData)
        //     .map<UserData>((product) => UserData.fromJson(product))
        //     .toList();
        // setState(() {
        // });
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  Future CartListData(String Orderid) async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var value = {"order_id": Orderid};
    try {
      final response =
          await http.post(Uri.parse('${apiDomain().domain}orderDetailPartner'),
              body: jsonEncode(value),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print('sdf$productsData');
        // return OrderDetailParnter.fromJson(productsData);
        OrderDetailParnters.Items = List.from(productsData)
            .map<PartnerOrderDetail>(
                (product) => PartnerOrderDetail.fromJson(product))
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
    CartListData(orderid);
    getaddress(orderid);
    Future.delayed(Duration(seconds: 1), () {
      Get.off(OrderDetailPartner(
        orderstatus: orderstatus,
        orderid: orderid,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class OrderDetailPartner extends StatefulWidget {
  final orderid;
  final orderstatus;
  const OrderDetailPartner({super.key, this.orderid, this.orderstatus});

  @override
  State<OrderDetailPartner> createState() =>
      _CartPageState(orderid, orderstatus);
}

class _CartPageState extends State<OrderDetailPartner> {
  int quantity = 0;
  var image = 'assets/image 16.png';
  var Name = 'Double Door';
  var Price;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final orderid;
  final orderstatus;
  _CartPageState(this.orderid, this.orderstatus);
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

  Future getaddress(String Orderid) async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(Orderid);
    var value = {"order_id": Orderid};
    try {
      final response =
          await http.post(Uri.parse('${apiDomain().domain}deatilbyUser'),
              body: jsonEncode(value),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["userData"];
        print('sdasdff$productsData');
        return productsData;
        // getaddresspartner.Items = List.from(productsData)
        //     .map<UserData>((product) => UserData.fromJson(product))
        //     .toList();
        // setState(() {
        // });
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  Future CartListData(String Orderid) async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var value = {"order_id": Orderid};
    try {
      final response =
          await http.post(Uri.parse('${apiDomain().domain}orderDetailPartner'),
              body: jsonEncode(value),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print('sdf$productsData');
        // return OrderDetailParnter.fromJson(productsData);
        OrderDetailParnters.Items = List.from(productsData)
            .map<PartnerOrderDetail>(
                (product) => PartnerOrderDetail.fromJson(product))
            .toList();
        setState(() {});
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  Future Updatedata(String url, Object value, context) async {
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
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home_view()));
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
    CartListData(orderid);
    getConnectivity();
    getaddress(orderid);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home_view()));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: orderstatus == 'pending'
            ? Container(
                decoration: BoxDecoration(
                  boxShadow: [],
                  color: Colors.grey[200],
                ),
                height: Get.height * 0.13,
                width: Get.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total:  ',
                                style: TextStyle(
                                    color: appcolor.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '₹$Price',
                                style: TextStyle(
                                    color: appcolor.redColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              blockButton(
                                  widget: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  callback: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete'),
                                            content: Text('Are you sure?'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        var value = {
                                                          "order_id": orderid,
                                                          "status": 'cancel'
                                                        };
                                                        Updatedata(
                                                            'orderDetailPartner',
                                                            value,
                                                            context);
                                                      },
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: appcolor
                                                                .redColor),
                                                      ))
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                  }),
                              blockButton(
                                  color: Colors.green,
                                  widget: Text(
                                    AppLocalizations.of(context)!.confirm,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  callback: () {
                                    var value = {
                                      "order_id": orderid,
                                      "status": 'confirm'
                                    };
                                    Updatedata(
                                        'orderDetailPartner', value, context);
                                  }),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  boxShadow: [],
                  color: Colors.grey[200],
                ),
                height: Get.height * 0.13,
                width: Get.width,
              ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xffEEEEEE),
          title: Text(
            AppLocalizations.of(context)!.orderdetails,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Home_view()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              )),
        ),
        body: Column(
          children: [
            // FutureBuilder(
            //   future: getaddress(orderid),
            //   builder: (context, snapshot){
            //     if(snapshot.hasError){
            //       return Text('');
            //     }else if(snapshot.hasData){
            //       return ListView.builder(
            //           itemCount: snapshot.data.length,
            //           itemBuilder: (context, index){
            //             var data = snapshot.data[index];
            //             return Card(child: Column(children: [
            //               Text('${data['name']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            //
            //               Text('${data['city']}, ${data.state}, ${data.country}, ${data.pincode}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
            //               Text('${data['mobileNo']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            //             ],),);
            //
            //           });
            //     }else{
            //       return Center(child: CircularProgressIndicator());
            //     }
            //   },
            // )
            Container(
                height: Get.height * 0.12,
                child: FutureBuilder(
                  future: getaddress(orderid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('');
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data[index];
                            return Card(
                              child: Column(
                                children: [
                                  Text(
                                    '${data['name']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${data['mobile_no']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${data['address']},',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      '${data['city']}, ${data['state']}, ${data['country']}, ${data['pincode']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )

                // getaddresspartner.Items.isNotEmpty && getaddresspartner.Items != null?
                //     ListView.builder(
                //         itemCount: getaddresspartner.Items.length,
                //         itemBuilder: (context, index){
                //           var data = getaddresspartner.Items[index];
                //           return Card(child: Column(children: [
                //             Text('${data.name}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                //             Text('${data.city}, ${data.state}, ${data.country}, ${data.pincode}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                //             Text('${data.mobileNo}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                //           ],),);
                //         }):Center(child: CircularProgressIndicator(),),
                ),
            Expanded(
              child: OrderDetailParnters.Items.isNotEmpty &&
                      OrderDetailParnters.Items != null
                  ? ListView.builder(
                      itemCount: OrderDetailParnters.Items.length,
                      itemBuilder: (context, index) {
                        var data = OrderDetailParnters.Items[index];
                        var totalCost = double.parse(data.price.toString()) *
                            double.parse(data.quantity.toString());
                        return Card(
                          elevation: 4,
                          color: Color(0xffEEEEEE),
                          child: ListTile(
                            leading: Container(
                                height: 50,
                                width: 47,
                                child: Image.network(
                                  '${apiDomain().imageUrl + data.image.toString()}',
                                  fit: BoxFit.contain,
                                )),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: appcolor.redColor,
                                          height: 2,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ": ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.4,
                                      child: Text(
                                        data.productName.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 0.9,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.price,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: appcolor.redColor,
                                        height: 0.9,
                                      ),
                                    ),
                                    Text(
                                      data.size.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 0.9,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.price,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: appcolor.redColor,
                                            height: 0.9,
                                          ),
                                        ),
                                        Text(
                                          " : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red),
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
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.qty,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: appcolor.redColor,
                                            height: 0.9,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 0.9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.code,
                                      style:
                                          TextStyle(color: appcolor.redColor),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      '${data.code}',
                                      style: TextStyle(color: appcolor.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  double getTotal() {
    double total = 0.0;
    setState(() {
      OrderDetailParnters.Items.forEach((element) {
        total += (int.parse(element.price.toString()))! *
            (int.parse(element.quantity.toString()));
      });
    });
    setState(() {
      Price = double.parse('$total');
    });
    return total;
  }
}
