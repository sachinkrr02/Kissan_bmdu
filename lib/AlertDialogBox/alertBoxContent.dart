
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kisaan_electric/Moddal/cartList.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/home/view/home_view.dart';

import '../CartPage.dart';
import '../global/blockButton.dart';
import '../products/view/product_view.dart';

Future alertBoxdialogBox(context,String title,content){
  return
    showDialog(
        context: context, builder: (BuildContext contex){
      return AlertDialog(
        title: Text(title, style: TextStyle(color: appcolor.redColor,fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset('assets/img_10.png',),
            Text(content) ,
          ],
        ),
        actions: [
          Container(
            height: Get.height * 0.055,
            child: blockButton(
              callback: () {
                Get.back();
              },
              width: Get.width * 0.9,
              widget: Text(
                'Ok',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              verticalPadding: 3,
            ),
          ),
        ],
      );
    });

}
Future AlertBoxdialogBoxes(context,String title,content){
  return
    showDialog(
        context: context, builder: (BuildContext contex){
      return AlertDialog(
        title: Text(title, style: TextStyle(color: appcolor.redColor,fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset('assets/img_10.png',),
            Text(content) ,
          ],
        ),
        actions: [
          Container(
            height: Get.height * 0.055,
            child: blockButton(
              callback: () {
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex)=>product_view()));
                Get.offAll(Home_view());
              },
              width: Get.width * 0.9,
              widget: Text(
                'Ok',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              verticalPadding: 3,
            ),
          ),
        ],
      );
    });

}
Future AlertBoxdialogBoxe(context,String title,content){
  return
    showDialog(
        context: context, builder: (BuildContext contex){
      return AlertDialog(
        title: Text(title, style: TextStyle(color: appcolor.redColor,fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset('assets/img_10.png',),
            Text(content) ,
          ],
        ),
        actions: [
          Container(
            height: Get.height * 0.055,
            child: blockButton(
              callback: () {
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex)=>product_view()));
                Get.off(CartPage());
              },
              width: Get.width * 0.9,
              widget: Text(
                'Ok',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              verticalPadding: 3,
            ),
          ),
        ],
      );
    });

}