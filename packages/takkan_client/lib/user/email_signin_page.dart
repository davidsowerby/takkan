import 'package:flutter/material.dart';
import 'package:takkan_client/user/email_login_section.dart';
import 'package:takkan_client/user/user_state.dart';
import 'package:provider/provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';

class EmailSignInPage extends StatelessWidget {
  static const String emailHintText =
      "If you already have a Kayman account with a different club, it is easier just to use the same log in email.  You can still use a different email address to communicate with each club if you wish.";
  static const String passwordHint =
      "Use your existing password if you have one, or if this is a new Kayman account, create a password ";

  final String successRoute;
  final String failureRoute;
  final Map<String, dynamic> pageArguments;
  final IDataProvider dataProvider;

  const EmailSignInPage({
    required this.successRoute,
    required this.failureRoute,
    required this.pageArguments,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create: (_) => UserState(dataProvider.authenticator),
      child: Scaffold(
        // pageTitle: "Login / Register",
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView(
              children: <Widget>[
                Text('App Name Here'),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: EmailLoginSection(
                    successRoute: successRoute,
                    failureRoute: failureRoute,
                    dataProvider: dataProvider,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
