import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_app_project1/ui/first_page.dart';
import 'package:flutter_app_project1/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ui/login_page.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FirstPageIndex())],
      child: MaterialApp(
        title: 'Flutter Main',
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
        ),
        home: AnimatedSplashScreen(
          backgroundColor: Colors.blueGrey,
          duration: 3000,
          splash: Image.asset('images/fire.png'),
          nextScreen: FirstPage(),
          pageTransitionType: PageTransitionType.fade,
        ),
      ),
    );
  }
}
