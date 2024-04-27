import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import '../AlertDialogBox/alertBoxContent.dart';
import '../server/apiDomain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPage();
}

class _OfferPage extends State<OfferPage> {
  int totalPoint = 0;
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
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              customAppBar('${AppLocalizations.of(context)!.offers}', ''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                AppLocalizations.of(context)!.comingSoon,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ))

              // CarouselSlider(
              //   options: CarouselOptions(
              //       autoPlay: true,
              //       enlargeCenterPage: true,
              //       viewportFraction: 1,
              //       aspectRatio: 2.0,
              //       initialPage: 1,
              //       height: 100
              //   ),
              //   //carouselController: buttonCarouselController,
              //   items: [ 'assets/image 1.png', 'assets/image 1.png', 'assets/image 1.png'].map((i) {
              //     return Builder(
              //       builder: (BuildContext context) {
              //         return Container(
              //             width: Get.width,
              //             // height: Get.height* 0.1,
              //             child:Image.asset(i,fit: BoxFit.cover,)
              //         );
              //       },
              //     );
              //   }).toList(),
              // ),
              // Expanded(
              //   child: FutureBuilder(
              //       future: Schems(),
              //       builder: (context, snapshot){
              //         if(snapshot.hasError){
              //           return Center(child: Image.asset('assets/img_15.png'),);
              //         }else if(snapshot.connectionState == ConnectionState.waiting){
              //           return Center(child: CircularProgressIndicator(),);
              //         }else if(snapshot.hasData){
              //           var points= snapshot.data;
              //           return ListView.builder(
              //               itemCount: points.length,
              //               itemBuilder: (context, index){
              //                 final data  = snapshot.data[index];
              //                 return Card(
              //                   child: ListTile(
              //                     title: Text('${data['title']}'),
              //                     subtitle: Text('${data['point']}'),
              //                     leading: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlC7Ov5Xn8LBou-KHW9phWsWSQsa70Yec_js6FZEKM&s'),
              //                     trailing:  totalPoint >= int.parse( data['point'].toString())? blockButton(
              //                         callback: (){
              //                           var de = data['id'];
              //                           var value ={
              //                             "id":de
              //                           };
              //                           showDialog(context: context, builder: (context){
              //                             return AlertDialog(
              //                               title: Text('Please Conform',style: TextStyle(color: appcolor.redColor),),
              //                               content: Column(
              //                                 mainAxisSize: MainAxisSize.min,
              //                                 children: [
              //                                   Text('${data['title']}'),
              //                                 ],
              //                               ),
              //                               actions: [
              //                                 Container(
              //                                   height: Get.height * 0.055,
              //
              //                                   child: blockButton(
              //                                     callback: () {
              //                                       Navigator.pop(context);
              //                                     },
              //                                     width: Get.width * 0.3,
              //                                     widget: Text(
              //                                       'Cancel',
              //                                       style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                           fontWeight: FontWeight.bold,
              //                                           height: 1.2),
              //                                     ),
              //                                     verticalPadding: 3,
              //                                   ),
              //                                 ),
              //                                 SizedBox(width: 10,),
              //                                 Container(
              //                                   height: Get.height * 0.055,
              //                                   child: blockButton(
              //                                     callback: () {
              //                                       Update('offer', value, context);
              //
              //
              //
              //                                     },
              //                                     width: Get.width * 0.3,
              //                                     widget: Text(
              //                                       'Ok',
              //                                       style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                           fontWeight: FontWeight.bold,
              //                                           height: 1.2),
              //                                     ),
              //                                     verticalPadding: 3,
              //                                   ),
              //                                 ),
              //                               ],
              //                             );
              //                           });
              //
              //                         },
              //                         widget: Text('Reedem',style: TextStyle(color: Colors.white),)
              //                     ):null,
              //                   ),
              //                 );
              //               });
              //         }else{
              //           return Center(child: CircularProgressIndicator(),);
              //         }
              //       }),
              // ),
            ],
          ),
          floatingActionButton: floatingActionButon(context),
        ),
      ),
    );
  }

  Future Schems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}offer'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final point = data['point'];
      // prefs.setInt('point', point);
      totalPoint = point == null ? 0 : point;
      // print(point);
      final dataa = data['data']['scheme'];
      print(data);
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
                        Navigator.pop(context);
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
