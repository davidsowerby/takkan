
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/user/emailLoginSection.dart';

class
EmailSignInPage extends StatelessWidget {
  static const String emailHintText =
      "If you already have a Kayman account with a different club, it is easier just to use the same log in email.  You can still use a different email address to communicate with each club if you wish.";
  static const String passwordHint =
      "Use your existing password if you have one, or if this is a new Kayman account, create a password ";

  final String outBoundAction;

  const EmailSignInPage({@required this.outBoundAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // pageTitle: "Login / Register",
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                children: <Widget>[Text ('App Name Here'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                  child: EmailLoginSection(nextRoute: "/member/home"),
                ),
                ]
              )),
        ));
  }
}
