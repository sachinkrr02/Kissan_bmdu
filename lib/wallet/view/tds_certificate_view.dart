import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/global/blockButton.dart';
import 'package:kisaan_electric/global/customAppBar.dart';
import 'package:kisaan_electric/global/customtextformfield.dart';
import 'package:kisaan_electric/global/gradient_text.dart';

import '../../whatsaapIcon/WhatsaapIcon.dart';

class tds_certificate_view extends StatefulWidget {
  const tds_certificate_view({super.key});

  @override
  State<tds_certificate_view> createState() => _tds_certificate_viewState();
}

class _tds_certificate_viewState extends State<tds_certificate_view> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
        color: Colors.white
        //   image: DecorationImage(
        //       image: AssetImage('assets/rectangle.png'), fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              customAppBar('TDS Details',''),
              Container(
                height: 1,
                width: Get.width,
                color: appcolor.borderColor,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'TDS Details',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                height: Get.height * 0.3,
                width: Get.width * 0.8,
                decoration: BoxDecoration(
                    color: appcolor.greyColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: Center(
                    child: Text(
                  'No Data Available',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ),
              SizedBox(height: 10,),
               Text(
                'TDS Certificate',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                height: Get.height * 0.3,
                width: Get.width * 0.8,
                decoration: BoxDecoration(
                    color: appcolor.greyColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: Center(
                    child: Text(
                  'No Data Available',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ),
            ],
          ),
          floatingActionButton:floatingActionButon(context),
        ),
      ),
    );
  }
}
