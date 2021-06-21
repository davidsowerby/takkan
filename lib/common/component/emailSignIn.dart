import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_client/app/router.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/common/component/messagePanel.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/trait/text.dart';
import 'package:precept_client/trait/traitLibrary.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/signin/signIn.dart';

class EmailSignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final PEmailSignIn config;
  final ContentBindings contentBindings;

  EmailSignIn({Key? key, required this.config, required this.contentBindings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = contentBindings.dataProvider.authenticator.status;
    switch (status) {
      case SignInStatus.Authenticating:
        return Center(child: MessagePanel(message: config.checkingCredentialsMessage));
      case SignInStatus.Uninitialized:
      case SignInStatus.Initialised:
      case SignInStatus.Unauthenticated:
      case SignInStatus.Authentication_Failed:
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: keys(key, ['emailField']),
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: config.emailCaption,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: keys(key, ['usernameField']),
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.supervised_user_circle),
                    labelText: config.usernameCaption,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: keys(key, ['passwordField']),
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.security),
                    labelText: config.passwordCaption,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (status == SignInStatus.Authentication_Failed) failureMessage(theme),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    child: Text(config.submitCaption),
                    onPressed: () => submitCredentials(context, contentBindings)),
              )
            ],
          ),
        );
      case SignInStatus.Authenticated:
        return Center(child: MessagePanel(message: 'Successful'));
      case SignInStatus.Removing_Registration:
      case SignInStatus.Reset_Requested:
      case SignInStatus.Registering:
      case SignInStatus.Registered:
      case SignInStatus.Registration_Failed:
      case SignInStatus.Registration_Removed:
      case SignInStatus.User_Not_Known:
        throw PreceptException('Should not be here ...  should have gone to another route');
    }
  }

  /// Submits credentials for email log in, and navigate to the next route.
  /// The next route is determined by:
  ///
  /// - [config.successRoute] if it is not empty
  /// - If [config.successRoute] is empty, navigate to page user was going to before interrupted by sign in,
  /// held by [router.preSignInRoute]
  /// - If [router.preSignInRoute] is null, default to '/'
  submitCredentials(BuildContext context, ContentBindings contentBindings) async {
    AuthenticationResult result = await contentBindings.dataProvider.authenticator.signInByEmail(
      username: emailController.text,
      password: passwordController.text,
    );
    if (result.success) {
      /// Remove the sign in pages from Navigator history
      Navigator.of(context).popUntil(_notSignInRoute);

      /// And also the incomplete page caused by jumping off to sign in
      Navigator.of(context).pop();
      final nextRoute = (config.successRoute == '')
          ? (router.preSignInRoute == null)
              ? '/'
              : router.preSignInRoute
          : config.successRoute;
      Navigator.of(context).pushNamed(nextRoute!);
    } else {
      logType(this.runtimeType).d("login unsuccessful");
    }
  }

  bool _notSignInRoute(Route route) {
    String? routePath = route.settings.name;
    return (routePath == null) ? true : !routePath.toLowerCase().contains('signin');
  }

  Widget failureMessage(ThemeData theme ){

    final TextTrait trait=traitLibrary.findParticleTrait(
        theme: theme, traitName: PText.errorText) as TextTrait;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        config.signInFailureMessage,
        style: trait.textStyle,
        textAlign: trait.textAlign,
      ),
    );
  }
}
