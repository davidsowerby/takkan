import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/userState.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/common/component/messagePanel.dart';
import 'package:precept_client/common/component/text.dart';
import 'package:precept_client/common/page/layout.dart';
import 'package:precept_script/common/log.dart';

const String createPasswordText =
    "If this is a new account, create a password of at least 8 characters, containing at least one letter, one capital letter and one number";

class EmailLoginSection extends StatefulWidget {
  final String passwordHint;
  final String successRoute;
  final String failureRoute;
  final DataProvider dataProvider;

  const EmailLoginSection({
    Key key,
    this.passwordHint = "Enter your password",
    @required this.successRoute,
    @required this.failureRoute,
    @required this.dataProvider,
  }) : super(key: key);

  @override
  _EmailLoginSectionState createState() => _EmailLoginSectionState();
}

class _EmailLoginSectionState extends State<EmailLoginSection> with DisplayColumns {
  TextEditingController emailController;
  TextEditingController passwordController;
  bool showPasswordBox = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = widget.dataProvider;
    final screenSize = MediaQuery.of(context).size;
    final dim = dimensions(screenSize: screenSize);
    logType(this.runtimeType).d("login status is ${dataProvider.userState.status}");
    switch (dataProvider.userState.status) {
      case SignInStatus.Authenticated:
        dataProvider.userState.newToSystem = false;
        return Container(
          width: dim.columnWidth,
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      case SignInStatus.Authenticating:
        return Center(
          child: MessagePanel(
            key: keys(widget.key, ['messagePanel']),
            message: "Checking credentials",
          ),
        );
      case SignInStatus.Registering:
        return Center(
          child: MessagePanel(
            key: keys(widget.key, ['messagePanel']),
            message: "Registering new account",
          ),
        );
      case SignInStatus.Registered:
        dataProvider.userState.newToSystem = true;
        final theme = Theme.of(context);
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: dim.columnWidth,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('A new account has been registered for:'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(dataProvider.user.email,
                      style: theme.textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AutoSizeText(
                    'Please complete the registration by responding to the verification email we have sent you',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.1,
                  ),
                ),
                RaisedButton(
                    child: Text('OK'), onPressed: () => registrationAcknowledged(dataProvider))
              ],
            ),
          ),
        );

      default:
        return Container(
          width: dim.columnWidth,
          height: 300,
          child: (showPasswordBox)
              ? passwordSection(dataProvider, dim.columnWidth)
              : usernameSection(dataProvider, dim.columnWidth),
        );
    }
  }

  usernameSection(DataProvider dataProvider, double columnWidth) {
    return Column(
      children: <Widget>[
        Container(
          width: columnWidth,
          child: TextFormField(
            key: keys(widget.key, ['emailField']),
            controller: emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email), labelText: "email", border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: RaisedButton(
            key: keys(widget.key, ['okButton']),
            child: Text('OK'),
            onPressed: () => checkUsername(dataProvider.userState),
          ),
        ),
      ],
    );
  }

  checkUsername(UserState userState) async {
    setState(() {
      showPasswordBox = true;
    });
  }

  passwordSection(DataProvider dataProvider, double columnWidth) {
    return Container(
      width: columnWidth,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Container(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextBlock(text: createPasswordText),
              )),
        ),
        Container(
          width: columnWidth,
          child: TextFormField(
            key: keys(widget.key, ['passwordField']),
            controller: passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                labelText: "password",
                border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (dataProvider.userState.status == SignInStatus.Authentication_Failed)
                  ? "The password or username is incorrect"
                  : "",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        RaisedButton(
          key: keys(widget.key, ['submitButton']),
          child: Text('Submit'),
          onPressed: () => submitCredentials(context, dataProvider),
        ),
        RaisedButton(
          child: Text("I've forgotten my password"),
          onPressed: () => forgottenPassword(dataProvider),
        ),
      ]),
    );
  }

  registrationAcknowledged(DataProvider dataProvider) async {
    await dataProvider.authenticator.registrationAcknowledged();
    Navigator.pushNamed(context, widget.successRoute);
  }

  /// Submits credentials for email log in.  A failed login automatically registers a new account (email and password are validated before submission).
  /// This does mean that an account could be incorrectly created
  submitCredentials(BuildContext context, DataProvider dataProvider) async {
    AuthenticationResult result = await dataProvider.authenticator
        .signInByEmail(username: emailController.text, password: passwordController.text);
    if (result.success) {
      /// Remove the sign in pages from Navigator history
      Navigator.of(context).popUntil(_notSignInRoute);
      Navigator.of(context).pushNamed(widget.successRoute);
    }else{
      logType(this.runtimeType).d("login unsuccessful");
    }
  }

  forgottenPassword(DataProvider dataProvider) {
    throw UnimplementedError('Forgotten password not implemented');
  }
  
  bool _notSignInRoute(Route route){
    return !route.settings.name.toLowerCase().contains('signin');
  }
}
