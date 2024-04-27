import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/CartPage.dart';

import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../whatsaapIcon/WhatsaapIcon.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});
  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  var image = 'assets/image 16.png';
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
            //   image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
            ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: customAppBar(AppLocalizations.of(context)!.orders, ''),
          ),
          backgroundColor: Colors.transparent,
          body:
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(height: 50,),
              //     Center(child: Text('Coming Soon',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),))
              //
              //   ],
              // ),

              FutureBuilder(
            future: api().GetData('orderhistory', ''),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Image.asset(apiDomain().nodataimage.toString()),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      return Card(
                        elevation: 4,
                        color: Color(0xffEEEEEE),
                        child: ListTile(
                          // leading: Container(
                          //     height: 50,
                          //     width: 50,
                          //     child: Image.asset(image,fit: BoxFit.cover,)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Order ID: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: appcolor.redColor,
                                          height: 0.9,
                                        ),
                                      ),
                                      Text(
                                        '${data['order_id']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 0.9,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Qty:  ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: appcolor.redColor,
                                          height: 0.9,
                                        ),
                                      ),
                                      Text(
                                        '${data['quantity']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 0.9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    color: data['status'] == 'cancelled'
                                        ? appcolor.redColor
                                        : data['status'] == 'pending'
                                            ? Colors.blueAccent
                                            : Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    '${data['status'] == 'cancelled' ? 'Cancelled' : data['status'] == 'pending' ? 'Pending' : 'Confirm'}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white),
                                  )),
                                ),
                              ),
                              // Column(
                              //   children: [
                              //     InkWell(
                              //       onTap: (){
                              //         Get.to(CartPage());
                              //       },
                              //       child: Container(
                              //         width: 100,
                              //         decoration: BoxDecoration(
                              //             color: Color(0xff02345f),
                              //             borderRadius: BorderRadius.all(Radius.circular(5))
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(5.0),
                              //
                              //           child: Center(child: Row(
                              //             children: [
                              //               Icon(Icons.repeat,color: Colors.white,),
                              //               Text('Repeat',style: TextStyle(fontWeight: FontWeight.w200,color: Colors.white),),
                              //             ],
                              //           )),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(height: 10,),
                              //
                              //   ],
                              // )
                            ],
                          ),

                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: appcolor.redColor,
                                          height: 0.9,
                                        ),
                                      ),
                                      Text(
                                        '${data['total_amount']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 0.9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
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
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }
}
