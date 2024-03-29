// ignore_for_file: use_build_context_synchronously
// import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:myfitwizz/constants/routes.dart';
import 'package:myfitwizz/services/auth/auth_exceptions.dart';
import 'package:myfitwizz/services/auth/auth_service.dart';
import 'package:myfitwizz/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  //Here we converted the previous Stateless homepage to a stateful one
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // These controllers are here to set a proxy of communication, to facilitate data retrievel between the TextField and the app itself. SO that input data can be used.
  late final TextEditingController _email;
  // "late" promises that the variable will be assigned a value "later"
  late final TextEditingController _password;

  // Stateful widgets have initState and dispose functions that intilizes and cleans the widgets.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  void dispse() {
    _email.dispose();
    _password.dispose();
    super.initState();
  }

  // Building the widget
  @override
  Widget build(BuildContext context) {
    // To make sure that the core flutter engine is in place.
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),
          TextButton(
            onPressed: () async {
              // devtools.log("Button Pressed");
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user's email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (_) => false,
                  );
                } else {
                  // user's email is not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (_) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "User not found",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Wrong Password!",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Authentication Error",
                );
              }
            },
            child: const Text("Log in"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Not registered yet? Register Now!"))
        ],
      ),
    );
    // Scaffold of the entire widget area, where the user can interact and etc.
    // return Scaffold(
    //   appBar: AppBar(title: const Text("Login")),

    //   // The body of the scaffold is wrapped inside a FutureBuilder widget because we want to build
    //   //   the widget based on the information we get from the future
    //   // Creates a widget that builds itself based on the latest snapshot of interaction with a [Future].
    //   body: FutureBuilder(
    //     // The future that it awaits is this:
    //     future: Firebase.initializeApp(
    //       options: DefaultFirebaseOptions.currentPlatform,
    //     ),
    //     // Then, it will build this, using the snapshot of the  future above:
    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           return (******************)
    //         default:
    //           return const Text("Loading...");
    //       }
    //     },
    //   ),
    // );
  }
}
