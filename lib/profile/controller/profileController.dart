import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class profilecontroller extends GetxController {
  DateTime? pickedDate;
  String profileDate='';

  Future<String> showdatepicker(BuildContext context) async {
    pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      print(
          pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(
          pickedDate!); // format date in required form here we use yyyy-MM-dd that means time is removed
        profileDate= formattedDate;
      print(
          formattedDate); //formatted date output using intl package =>  2022-07-04
      //You can format date as per your need
    } else {
      print("Date is not selected");
    }
    return profileDate;
  }
}
