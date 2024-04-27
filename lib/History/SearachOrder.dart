import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Moddal/historyOrder.dart';
import '../server/apiDomain.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchpageOrder extends SearchDelegate {
  var data = [];
  List<Data> results = [];

  Future<List<Data>> getuserList({String? query}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      var response =
          await http.post(Uri.parse('${apiDomain().domain}orderhistory'),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final rep = jsonDecode(
          response.body,
        );
        data = rep['data'];

        print(data);
        results = data.map((e) => Data.fromJson(e)).toList();

        if (query != null) {
          results = results
              .where((element) => element.orderId!
                  .toLowerCase()
                  .contains((query.toLowerCase())))
              .toList();
        }
        print(results);
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back,
          color: appcolor.redColor,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return FutureBuilder<List<Data>>(
        future: getuserList(query: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Data Not Found'));
          } else if (snapshot.hasData) {
            List<Data>? data = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 20,
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
                          child: Text(  AppLocalizations.of(context)!.orderid,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(  AppLocalizations.of(context)!.ordervalue,
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
                      ]),
                ]),
                Expanded(
                  child: ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        final dataa = data[index];
                        var date = dataa.createdAt;
                        var splits = date!.split('T');
                        var splity = splits[0];
                        var date1 = splity.split('-');
                        //   total = int.parse(data['Point']);
                        return Table(border: TableBorder.all(), children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${date1[2]}-${date1[1]}-${date1[0]}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${dataa.orderId}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${dataa.totalAmount}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${dataa.status}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                              ]),
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
        });
  }
}
