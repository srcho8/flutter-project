import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_dashboard_layout/menu_dashboard_layout.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  initializeDateFormatting().then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'InsFire Main',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blueGrey,
        ),
        home: SplashScreenView(
          home: MenuDashboardLayout(),
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
