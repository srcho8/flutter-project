import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:InsFire/faderoute.dart';
import 'package:InsFire/menu_dashboard_layout/menu_dashboard_layout.dart';
import 'package:InsFire/sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  InterstitialAd myInterstitial;

  @override
  void initState() {
    super.initState();
    myInterstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial.load();
        }
        print("InterstitialAd event is $event");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/fire.png",
                height: 150,
              ),
              Text(
                'InsFire',
                style:
                    GoogleFonts.indieFlower(color: Colors.white, fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () {
                  myInterstitial.load();
                  signInWithGoogle().then((result) {
                    if (result != null) {
                      if (myInterstitial.isLoaded() != null) {
                        myInterstitial
                            .show(
                          anchorType: AnchorType.bottom,
                          anchorOffset: 0.0,
                          horizontalCenterOffset: 0.0,
                        )
                            .then((value) {
                          Navigator.push(
                            context,
                            FadeRoute(page: MenuDashboardLayout()),
                          );
                        });
                      } else {
                        myInterstitial
                            .show(
                          anchorType: AnchorType.bottom,
                          anchorOffset: 0.0,
                          horizontalCenterOffset: 0.0,
                        )
                            .then((value) {
                          Navigator.push(
                            context,
                            FadeRoute(page: MenuDashboardLayout()),
                          );
                        });
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
