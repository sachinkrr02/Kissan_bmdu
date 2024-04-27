import 'package:flutter/material.dart';
import 'package:get/get.dart';

class wallet_controller  extends GetxController with GetSingleTickerProviderStateMixin{

  late TabController tabcontroller;
  
  @override
  void onInit() {
    // TODO: implement onInit

    tabcontroller = TabController(length: 4, vsync: this);
    
    super.onInit();
  }

}