import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/provider/provider_memolist.dart';
import 'package:flutter_app_project1/ui/first_page.dart';
import 'package:flutter_app_project1/provider/provider_homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'ui/login_page.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  List<Memo> _memoList = [];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirstPageIndex()),
        ChangeNotifierProvider(create: (_) => MemoProvider(_memoList))
      ],
      child: MaterialApp(
          title: 'InsFire Main',
          theme: ThemeData(
            primaryColor: Colors.blueGrey,
          ),
          home: SplashScreenView(
            home: FirstPage(),
            duration: 3000,
            imageSize: 150,
            imageSrc: "images/fire.png",
            text: "InsFire",
            textType: TextType.TyperAnimatedText,
            textStyle: GoogleFonts.indieFlower(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.blueGrey,
          )),
    );
  }
}


class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset('images/fire.png'),
          Text(
            'InsFire',
            style: GoogleFonts.indieFlower(),
          ),
        ],
      ),
    );
  }
}
