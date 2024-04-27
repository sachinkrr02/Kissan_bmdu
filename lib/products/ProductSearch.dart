import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/products/view/detailed_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Moddal/ProductModal.dart';
import '../server/apiDomain.dart';
import 'package:http/http.dart'as http;

class ProductSearch extends SearchDelegate{
  var data = [];
  List<DataProduct> results = [];

  Future<List<DataProduct>> getuserList({String? query}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      var response = await http.post(Uri.parse('${apiDomain().domain}allProduct'),  headers: ({
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }));

      if (response.statusCode == 200) {
        final rep = jsonDecode(response.body,);
        data = rep['data'];

        print(data);
        results = data.map((e) => DataProduct.fromJson(e)).toList();

        if (query!= null){
          results = results.where((element) => element.name!.toLowerCase().contains((query.toLowerCase()))).toList();
        }
        print(results);
      }else if(response.statusCode ==404){
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

    return  FutureBuilder<List<DataProduct>>(
        future: getuserList(query: query),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Center(child: Text('Data Not Found'));
          }else if(snapshot.hasData){
            List<DataProduct>? data = snapshot.data;
            return
             ListView.builder(
                 itemCount: data!.length,
                 itemBuilder:
                 (context,index){
               return Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10),
                 child: ListTile(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>detailedProductView(name: data[index].id,)));
                   },
                     title: Text(data[index].name.toString())),
               );
             });
          }else{
            return Center(child: CircularProgressIndicator(),);
          }

        });
  }

}