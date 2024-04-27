import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kisaan_electric/server/apiDomain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/customAppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class schemeFilter extends StatefulWidget {
  final startDate;
  final enddate;
  final String url;
  final int conditon;
  const schemeFilter(
      {super.key,
      this.startDate,
      this.enddate,
      required this.url,
      required this.conditon});

  @override
  State<schemeFilter> createState() =>
      _transerFiler(startDate, enddate, url, conditon);
}

class _transerFiler extends State<schemeFilter> {
  final startDate;
  final endDate;
  final String url;
  final int condition;

  _transerFiler(this.startDate, this.endDate, this.url, this.condition);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: customAppBar(
            'Filter',
            '',
          ),
        ),
        body: FutureBuilder(
            future: filter('$url', startDate, endDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Data Not Found');
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Table(border: TableBorder.all(), children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.grey[300]),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.scheme,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.points,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ]),
                    ]),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data[index];
                            var date = data['created_at'];
                            var splits = date.split('T');
                            var splity = splits[0];
                            var date1 = splity.split('-');
                            // total = int.parse(data['Point']);
                            return Table(border: TableBorder.all(), children: [
                              TableRow(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${date1[2]}-${date1[1]}-${date1[0]}',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${data['scheme_name']}',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${data['status']}',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${data['point']}',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ]),
                              // TableRow(
                              //     children :[
                              //       Text('Date',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              //       Text('${data['QR_Code']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              //       Text('${data['Reference']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              //       Text('${data['Point']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              //     ]),
                            ]);
                          }),
                    )
                  ],
                ).paddingSymmetric(
                  horizontal: 10,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Future filter(String url, key, key1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var value = {"start": key, "end": key1};
    print(url);
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
      print(data);
      return data['data'];
    } else if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
  }
}
