import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/gradient_text.dart';
import 'package:kisaan_electric/home/view/home_view.dart';

Container customAppBar(String title,value) {
  return Container(
    color: Colors.transparent,
    child: Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GradientText(
          gradient: appcolor.gradient,
          widget: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,color: appcolor.redColor,
            ),
            onPressed: () {
              if(value == ''){
                Get.back();
              }else{
                Get.offAll(Home_view());
              }

            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        GradientText(
          widget: Text(
            title,
            style: TextStyle(
              height: 2,
              fontSize: 22,color: appcolor.redColor
            ),
          ),
          gradient: appcolor.gradient,
        ),
      ],
      
    ),
  );
}
