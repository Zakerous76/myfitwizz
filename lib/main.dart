// ignore_for_file: unused_local_variable

// ignore: unused_import
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:myfitwizz/constants/routes.dart';
import 'package:myfitwizz/services/auth/auth_service.dart';
import 'package:myfitwizz/views/login_view.dart';
import 'package:myfitwizz/views/notes_view.dart';
import 'package:myfitwizz/views/register_view.dart';
import 'package:myfitwizz/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await AuthService.firebase().initialize();

  runApp(MaterialApp(
    // we are straight up returning the Material from here rather than returning a separate MyApp instance becasue this yields more performance
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) =>
          const LoginView(), // returns an instance of the loginview
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      mainRoute: (context) => const HomePage(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            // // "If the user is non-null, take it. If the user is null then take false"
            // if (user?.emailVerified ?? false) {
            //   return const Text("Done");
            // } else {
            //   print("You are NOT verified, you need to verify my nigga!");
            //   // Navigator.of(context).push(MaterialPageRoute(          // Since we are returning a "Column" rather than a scaffold widget from the VerifyEmailView()
            //   //     builder: (context) => const VerifyEmailView()));
            // }
            // return const Text("Done");

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
