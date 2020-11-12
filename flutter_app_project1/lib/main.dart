import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        brightness: Brightness.dark,

      ),
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: FlutterLogo(size: 400),
        nextScreen: LoginPage(),
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}