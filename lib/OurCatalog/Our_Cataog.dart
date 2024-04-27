import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../whatsaapIcon/WhatsaapIcon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Our_Catalog extends StatefulWidget {
  const Our_Catalog({super.key});
  @override
  State<Our_Catalog> createState() => _Our_Catalog();
}

class _Our_Catalog extends State<Our_Catalog> {
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
            title:
                customAppBar('${AppLocalizations.of(context)!.ourCatalog}', ''),
          ),
          backgroundColor: Colors.transparent,
          body: FutureBuilder(
            future: GetData('catalog', ''),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Image.asset('${apiDomain().nodataimage}'),
                );
              } else if (snapshot.hasData) {
                var data = snapshot.data;
                return SfPdfViewer.network(
                    '${apiDomain().imageUrl + data['data']}');
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

  Future GetData(String url, key) async {
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
      //   prefs.setString('electrician', data['profession']);
      print(data);
      return data;
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
