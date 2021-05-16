import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/user/userState.dart';
import 'package:precept_script/signin/signIn.dart';
import 'package:provider/provider.dart';

class EmailSignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final PEmailSignIn config;
  final ContentBindings contentBindings;

  EmailSignIn({Key key, @required this.config, @required this.contentBindings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    return Container(
      child: Column(
        children: [
          TextFormField(
            key: keys(key, ['usernameField']),
            controller: usernameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.supervised_user_circle),
              labelText: config.usernameLabel,
              border: OutlineInputBorder(),
            ),
          ),
          TextFormField(
            key: keys(key, ['emailField']),
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: config.emailLabel,
              border: OutlineInputBorder(),
            ),
          ),
          TextFormField(
            key: keys(key, ['passwordField']),
            controller: passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.security),
              labelText: config.passwordLabel,
              border: OutlineInputBorder(),
            ),
          ),
          TextButton(
              child: Text(config.submitLabel),
              onPressed: () => {
                    contentBindings.dataProvider.authenticator.signInByEmail(
                      username: usernameController.text,
                      password: passwordController.text,
                    )
                  })
        ],
      ),
    );
  }
}
