import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/StartingUi/welcome_screen.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class splashScreen extends StatefulWidget {
  splashScreen({super.key});
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3),(){
      Get.off(welcomeScreen());
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child:Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 0
                    )
                  ],
                  color: Color(0xffDD2B1C
                  ),

                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(150,90)

                  )
              ),
              height: Get.height * 0.7,
              width: Get.width,
            ),
            // AnimatedSplashScreen(splash: Expanded(
            //     child:Padding(
            //       padding: const EdgeInsets.only(top:120 ),
            //       child: Center(
            //           child: Image.asset('assert/plain logo.png',color: Colors.white,)),
            //     )),
            //     splashIconSize:MediaQuery.of(context).size.width,
            //     splashTransition: SplashTransition.sizeTransition,
            //     backgroundColor: Colors.redAccent,
            //     duration: 100000,
            //     pageTransitionType: PageTransitionType.leftToRight,
            //     nextScreen: welcomeScreen()),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child:Image.asset('assets/kissanlogo.png',color:Colors.white,fit: BoxFit.cover,width: 180,),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
