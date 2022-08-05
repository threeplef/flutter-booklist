import 'package:book_list_app/book_list/book_list_screen.dart';
import 'package:book_list_app/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          }
          return BookListScreen();
        });
  }
}
