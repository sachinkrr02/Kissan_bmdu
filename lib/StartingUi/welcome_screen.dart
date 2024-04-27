import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/auth/login/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/view/home_view.dart';

class welcomeScreen extends StatefulWidget {
  welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
  void initState() {
    super.initState();
    whertogo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: Colors.white
            // image: DecorationImage(
            //   image: AssetImage('assets/rectangle.png'),
            //   fit: BoxFit.fill,
            // ),
            ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: Get.height * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/Welcome_In_Kisaan.png',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: Get.height * 0.5,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/hellopng 1.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future whertogo() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getString('token');
    print(isLoggedIn);
    Timer(
        Duration(
          seconds: 2,
        ), () async {
      if (isLoggedIn != null) {
        if (isLoggedIn != '') {
          Get.offAll(Home_view());
        } else {
          Get.offAll(login_view());
        }
      } else {
        Get.offAll(login_view());
      }
    });
  }
}
