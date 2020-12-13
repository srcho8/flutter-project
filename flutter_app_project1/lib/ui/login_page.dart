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
                  signInWithGoogle().then((result) {
                    if (result != null) {
                      Navigator.push(
                        context,
                        FadeRoute(page: MenuDashboardLayout()),
                      );
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
