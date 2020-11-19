import 'package:flutter/material.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/ui/first_page.dart';
import 'package:flutter_app_project1/sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              SignInButton(
                Buttons.GoogleDark,
                text: "Sign up with Google",
                onPressed: () {
                  signInWithGoogle().then((result) {
                    if (result != null) {
                      Navigator.push(context, FadeRoute(page: FirstPage()), );
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
