
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../global/blockButton.dart';

Widget AlertProcessing(String title,content){
  return
    AlertDialog(
      title: Text(title),
      content: CircularProgressIndicator(),
    );

}