import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:InsFire/ui/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  initializeDateFormatting().then((_) async {
    runApp(ProviderScope(child: MyApp()));
    await Firebase.initializeApp();
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-3940256099942544~1458002511');

    return MaterialApp(
        title: 'InsFire',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blueGrey,
        ),
        home: SplashScreenView(
          home: LoginPage(),
          duration: 2500,
          imageSize: 150,
          imageSrc: "images/fire.png",
          text: "InsFire",
          textType: TextType.TyperAnimatedText,
          textStyle: GoogleFonts.indieFlower(
            fontSize: 30.0,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.blueGrey,
        ));
  }
}
