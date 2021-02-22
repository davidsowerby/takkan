
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/common/component/messagePanel.dart';
import 'package:precept_client/common/component/text.dart';
import 'package:precept_client/common/page/displayColumns.dart';
import 'package:precept_client/user/userState.dart';
import 'package:precept_script/common/log.dart';
import 'package:provider/provider.dart';

const String createPasswordText =
    "If this is a new account, create a password of at least 8 characters, containing at least one letter, one capital letter and one number";

class EmailLoginSection extends StatefulWidget {
  final String passwordHint;
  final String nextRoute;

  const EmailLoginSection({Key key, this.passwordHint = "Enter your password", @required this.nextRoute})
      : super(key: key);

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
    final userState = Provider.of<UserState>(context);
    final screenSize = MediaQuery.of(context).size;
    final dim = dimensions(screenSize: screenSize);
    logType(this.runtimeType).d("login status is ${userState.status}");
    switch (userState.status) {
      case SignInStatus.Authenticated:
          userState.newToSystem = false;
        return Container(
          width: dim.columnWidth,
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      case SignInStatus.Authenticating:
        return Center(
          child: MessagePanel(
            key: keys(widget.key,['messagePanel']),
            message: "Checking credentials",
          ),
        );
      case SignInStatus.Registering:
        return Center(
          child: MessagePanel(
            key: keys(widget.key,['messagePanel']),
            message: "Registering new account",
          ),
        );
      case SignInStatus.Registered:
        userState.newToSystem = true;
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
                  child: Text(userState.user.email, style: theme.textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AutoSizeText(
                    'Please complete the registration by responding to the verification email we have sent you',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.1,
                  ),
                ),
                RaisedButton(child: Text('OK'), onPressed: () => registrationComplete(userState))
              ],
            ),
          ),
        );

      default:
        return Container(
          width: dim.columnWidth,
          height: 300,
          child: (showPasswordBox)
              ? passwordSection(userState, dim.columnWidth)
              : usernameSection(userState, dim.columnWidth),
        );
    }
  }

  usernameSection(UserState userState, double columnWidth) {
    return Column(
      children: <Widget>[
        Container(
          width: columnWidth,
          child: TextFormField(
            key: keys(widget.key,['emailField']),
            controller: emailController,
            decoration:
                InputDecoration(prefixIcon: Icon(Icons.email), labelText: "email", border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: RaisedButton(
            key: keys(widget.key,['okButton']),
            child: Text('OK'),
            onPressed: () => checkUsername(userState),
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

  passwordSection(UserState userState, double columnWidth) {
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
            key: keys(widget.key,['passwordField']),
            controller: passwordController,
            decoration:
                InputDecoration(prefixIcon: Icon(Icons.lock_open), labelText: "password", border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (userState.status == SignInStatus.Authentication_Failed)
                  ? "You appear to have a Kayman account, but password is incorrect"
                  : "",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        RaisedButton(
          key: keys(widget.key,['submitButton']),
          child: Text('Submit'),
          onPressed: () => submitCredentials(context, userState),
        ),
        RaisedButton(
          child: Text("I've forgotten my password"),
          onPressed: () => forgottenPassword(userState),
        ),
      ]),
    );
  }

  registrationComplete(UserState userState) async {
    final userRepo = UserProfileRepository();
    final userUpdate = {"uid": userState.user.objectId, "email": userState.user.email};
    await userRepo.saveUserProfile(userId: userState.userId, data: userUpdate);
    Navigator.pushNamed(context, widget.nextRoute);
  }

  /// Submits credentials for log in.  A failed login automatically registers a new account (email and password are validated before submission).
  /// This does mean that an account could be incorrectly created
  submitCredentials(BuildContext context, UserState userState) async {
    bool successful = await userState.signInWithEmail(emailController.text, passwordController.text);
    if (successful) {
      if (userState.status == SignInStatus.Authenticated) {
        Navigator.pushNamed(context, widget.nextRoute);
      }
    }
  }

  forgottenPassword(UserState userState) {
    throw UnimplementedError('Forgotten password not implemented');
  }
}
