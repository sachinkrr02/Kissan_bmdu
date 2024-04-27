import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../AlertDialogBox/alertBoxContent.dart';
import '../CartPage.dart';
import '../auth/login/view/login_view.dart';

class apiDomain{
  final domain = 'http://kisaanparivar.co.in/api/';
  final nodataimage = 'assets/img_15.png';
  login_view login= login_view();
  var imageUrl = 'http://kisaanparivar.co.in/storage/app/public/images/';
}
class api{
  Future Update(String url,Object value,context,int check)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(value);
    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.statusCode);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      //print(data['message']);
      if(data['status']== true){
      if(check ==1){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CartPage()));
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data['message']}')));
      }
      }else{
        alertBoxdialogBox(context, 'Alert', '${data['message']}');
      }
      return data[0];
    }else if(response.statusCode ==404){
      Get.offAll(apiDomain().login);
    }
  }
  Future GetData(String url,key)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.statusCode);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
   //   prefs.setString('electrician', data['profession']);
     // print(data);
      return data['data'];
    }else if(response.statusCode == 404){
      Get.offAll(apiDomain().login);
    }
  }
  Future filter(String url,key,key1)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var value ={
      "start":key,
      "end":key1
    };
    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
      print(response.statusCode);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      print(data);
      return data['data'];
    }else if(response.statusCode == 404){
      Get.offAll(apiDomain().login);
    }
  }
  Future Banner(String url,key)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(key);
    var value ={
      "id":key
    };

    final response = await http.post(Uri.parse('${apiDomain().domain}$url'),body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    // print(response.statusCode);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      //   prefs.setString('electrician', data['profession']);
      return data['banner'];
    }else if(response.statusCode ==404){
      Get.offAll(apiDomain().login);
    }
  }
}