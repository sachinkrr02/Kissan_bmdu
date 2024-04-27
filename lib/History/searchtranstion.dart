
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Moddal/historyTranstion.dart';
import '../server/apiDomain.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Searchpagetranstion extends SearchDelegate{
  var dataa = [];
  List<Historytransition> results = [];
  String urlList = 'https://jsonplaceholder.typicode.com/users/';

  Future<List<Historytransition>> getuserList({String? query}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      var response = await http.post(Uri.parse('${apiDomain().domain}transactionhistory'),  headers: ({
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }));
      if (response.statusCode == 200) {
        final rep = jsonDecode(response.body,);

        dataa = rep['data'];
        print(rep);

        results = dataa.map((e) => Historytransition.fromJson(e)).toList();
        if (query!= null){
          results = results.where((element) => element.status!.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else if(response.statusCode ==404){
        Get.offAll(apiDomain().login);
      }else {
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
      IconButton(onPressed: (){
        query = '';
      }, icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: Icon(Icons.arrow_back,color: appcolor.redColor,));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return  FutureBuilder<List<Historytransition>>(
        future: getuserList(query: query),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Text('Data Not Found');
          }else if(snapshot.hasData){
            List<Historytransition>? data = snapshot.data;
            return
              Column(
                children: [
                  SizedBox(height: 20,),
                  Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.grey[300]
                            ),
                            children :[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)!.date,style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)!.amount,style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)!.status,style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)!.points,style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                              ),
                            ]),

                      ]
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index){
                          final dataa = data[index];
                          var date = dataa.createdAt;
                          var splits = date!.split('T');
                          var splity = splits[0];
                          //   total = int.parse(data['Point']);
                          return   Table(
                              border: TableBorder.all(),
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    children :[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${splity}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${dataa.amount}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${dataa.status}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${dataa.point}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                      ),
                                    ]),
                                // TableRow(
                                //     children :[
                                //       Text('Date',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                //       Text('${data['QR_Code']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                //       Text('${data['Reference']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                //       Text('${data['Point']}',style: TextStyle(fontSize: 12,),textAlign:TextAlign.center),
                                //     ]),
                              ]
                          );
                        }),
                  )
                ],
              ).paddingSymmetric(
                horizontal: 10,
              );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }

        });
  }

}