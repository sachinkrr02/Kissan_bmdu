import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appcolor.dart';

Widget blockButton({
  Widget? widget,
  double? width,
  double? horizontalPadding,
  double? verticalPadding,
  double? borderradius,
  Color? color,
  Function()? callback,
}) {
  return InkWell(
    onTap: callback,
    child: Container(
      margin: EdgeInsets.all(4),
      width: width == null ? Get.width * 0.26 : width,
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding == null ? 14 : horizontalPadding,
          vertical: verticalPadding == null ? 10 : verticalPadding),
      decoration: BoxDecoration(
         color: color == null ?appcolor.redColor:color,
        borderRadius: BorderRadius.circular(borderradius==null?30:borderradius),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.red,
          //    blurRadius: 3,
          //   spreadRadius: 0
          // )
        ],
        // border: Border.all(
        //   color: appcolor.purpleColor,
        // ),
      ),
      child: Center(child: widget),
    ),
  );
}
