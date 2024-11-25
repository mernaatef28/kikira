import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kikira/core/api/appServiceTry.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/screens/filterbydate.dart';
import 'package:kikira/features/ui/screens/loginpage.dart';

import 'package:kikira/kiki_app.dart';

import 'core/api/geminiservicetry.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:AnimatedSplashScreen(
        splash: "assets/splash/splashscreenblack.gif",
        splashIconSize: 3000,
        centered: true,
        backgroundColor: colorManager.kikiBlack,
        duration: 5000,
        nextScreen: LoginPage()) //LoginPage() ,
    //KikiRaApp(userHospitalName: 'fhfhff', username: 'jfjffk',),


    //FilterByDate()
   // GemimiApp() ,
    //MyHomePage() ,

  ));

}
