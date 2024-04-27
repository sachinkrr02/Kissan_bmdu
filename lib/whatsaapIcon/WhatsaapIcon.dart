import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget floatingActionButon(context){
  return    SizedBox(
    height: 40,
    width: 40,
    child: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          launchWhatsapp(context);
        },child: FaIcon(FontAwesomeIcons.whatsapp,color: Colors.white,)

    ),
  );
}
launchWhatsapp(context) async {
  var whatsapp = "+91 8506001015";
  var whatsappAndroid = Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
  if (await canLaunchUrl(whatsappAndroid,)) {
    await launchUrl(whatsappAndroid,);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("WhatsApp is not installed on the device"),
      ),
    );
  }
}