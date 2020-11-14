import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_app_project1/first_page.dart';
import 'package:flutter_app_project1/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> FirstPageIndex())
      ],
      child: MaterialApp(
        title: 'Flutter Login',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: AnimatedSplashScreen(
          duration: 3000,
          splash: FlutterLogo(size: 400),
          nextScreen: FirstPage(),
          pageTransitionType: PageTransitionType.fade,
        ),
      ),
    );
  }
}
