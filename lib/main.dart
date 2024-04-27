import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisaan_electric/StartingUi/splash%20screen.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

String lg = "en";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();

  if (pref.containsKey("lang") && pref.getString('lang') != null) {
    switch (pref.getString("lang").toString()) {
      case "en":
        lg = "en";
        break;
      case "pt":
        lg = "pt";
        break;
      case "pa":
        lg = "pa";
        break;
      case "gu":
        lg = "gu";
        break;
      case "mr":
        lg = "mr";
        break;
      case "or":
        lg = "or";
        break;
      case "ne":
        lg = "ne";
        break;
    }
  } else {
    pref.setString("lang", "en");
  }

  runApp(Kisaan_Electric());
}

class Kisaan_Electric extends StatelessWidget {
  const Kisaan_Electric({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale(lg, ''),
        // Locale('pt'),
        // Locale('pb'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          hintColor: appcolor.mixColor,
          fontFamily: 'TenaliRamakrishna',
          textTheme: TextTheme()),
      home: splashScreen(),
    );
  }
}
