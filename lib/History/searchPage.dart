import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Moddal/historypage.dart';
import '../global/blockButton.dart';
import '../server/apiDomain.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Searchpage extends SearchDelegate {
  var data = [];
  List<Data> results = [];
  String urlList = 'https://jsonplaceholder.typicode.com/users/';

  Future<List<Data>> getuserList({String? query}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      var response =
          await http.post(Uri.parse('${apiDomain().domain}pointhistory'),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final rep = jsonDecode(
          response.body,
        );

        data = rep['data'];
        print(rep);

        results = data.map((e) => Data.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.qRCode!.toLowerCase().contains((query.toLowerCase())))
              .toList();
        }
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
            return Text('Data Not Found');
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
                          child: Text(AppLocalizations.of(context)!.status,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text(AppLocalizations.of(context)!.referenceCode,
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
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        final dataa = data[index];
                        var date = dataa.createdAt;
                        var splits = date!.split('T');
                        var splity = splits[0];
                        //   total = int.parse(data['Point']);
                        return Table(border: TableBorder.all(), children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${splity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${dataa.qRCode}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${dataa.reference}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${dataa.point}',
                                      style: TextStyle(
                                        fontSize: 12,
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
        });
  }
}
