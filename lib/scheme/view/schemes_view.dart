import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/view/home_view.dart';
import '../../server/apiDomain.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class schemes_view extends StatefulWidget {
  const schemes_view({super.key});
  @override
  State<schemes_view> createState() => _schemes_viewState();
}

class _schemes_viewState extends State<schemes_view> {
  int totalPoint = 0;
  bool isLoading = false;
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

  // @override
  // void initState() async{
  //   // TODO: implement initState
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //    totalPoint =  prefs.getInt('point')
  //    !;
  // }
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
        child: WillPopScope(
          onWillPop: () async {
            Get.offAll(Home_view());
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: customAppBar(AppLocalizations.of(context)!.schemes, '1'),
            ),
            backgroundColor: Colors.transparent,
            body: FutureBuilder(
                future: Schems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Image.asset('assets/img_15.png'),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    var points = snapshot.data;
                    return ListView.builder(
                        itemCount: points.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data[index];
                          var split = data['upto'].split('-');
                          return Card(
                            color: index % 2 == 0
                                ? Colors.grey.shade200
                                : Colors.grey.shade100,
                            child: ListTile(
                                title: Text(
                                  '${data['title']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Point: ${data['point']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '${split[2]}-${split[1]}-${split[0]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                leading: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(
                                        '${apiDomain().imageUrl + data['image']}')),
                                trailing: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      totalPoint >=
                                              int.parse(
                                                  data['point'].toString())
                                          ? Container(
                                              height: 30,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              appcolor
                                                                  .redColor),
                                                  onPressed: () {
                                                    var de = data['id'];
                                                    var value = {"id": de};
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Please Confirm',
                                                              style: TextStyle(
                                                                  color: appcolor
                                                                      .redColor),
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    '${data['title']}'),
                                                              ],
                                                            ),
                                                            actions: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    child:
                                                                        blockButton(
                                                                      callback:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      width: Get
                                                                              .width *
                                                                          0.3,
                                                                      widget:
                                                                          Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            height: 1.2),
                                                                      ),
                                                                      verticalPadding:
                                                                          3,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: Get
                                                                            .height *
                                                                        0.055,
                                                                    child:
                                                                        blockButton(
                                                                      callback:
                                                                          () {
                                                                        Update(
                                                                            'scheme',
                                                                            value,
                                                                            context);
                                                                      },
                                                                      width: Get
                                                                              .width *
                                                                          0.3,
                                                                      widget:
                                                                          Text(
                                                                        'Ok',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            height: 1.2),
                                                                      ),
                                                                      verticalPadding:
                                                                          3,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    'Reedem',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  )),
                                            )
                                          : Container(
                                              height: 0,
                                              width: 0,
                                            ),
                                      TextButton(
                                          onPressed: () {
                                            alertBoxdialogBox(context, 'Detail',
                                                '${data['detail']}');
                                          },
                                          child: Text(
                                            'Detail',
                                            style: TextStyle(
                                                color: appcolor.redColor),
                                          ))
                                    ],
                                  ),
                                )),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            floatingActionButton: floatingActionButon(context),
          ),
        ),
      ),
    );
  }

  Future Schems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}scheme'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final point = data['point'];

      totalPoint = point;
      print(totalPoint);

      final dataa = data['data']['scheme'];
      return dataa;
    }
  }

  Future Update(String url, Object value, context) async {
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
      if (data['status'] == true) {
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Congrulation',
                  style: TextStyle(
                      color: appcolor.redColor, fontWeight: FontWeight.w500),
                ),
                content: Text('${data['message']}'),
                actions: [
                  blockButton(
                      callback: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home_view()));
                      },
                      widget: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                      width: Get.width * 0.7)
                ],
              );
            });
      } else {
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
      // return data[0];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
