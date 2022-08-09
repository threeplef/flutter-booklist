import 'package:book_list_app/book_list/book_list_screen.dart';
import 'package:book_list_app/login/login_view_model.dart';
import 'package:book_list_app/sign_up/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final viewModel = LoginViewModel();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '이메일',
            ),
          ),
          TextField(
            controller: _passwordTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '패스워드',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  value.user!.emailVerified == true
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BookListScreen()))
                      : FlutterDialogInvaild();
                  return value;
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  FlutterDialogRegister();
                } else if (e.code == 'wrong-password') {
                  FlutterDialogPassword();
                }
              }
            },
            child: const Text('로그인'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
            child: const Text('회원가입'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.signInWithGoogle();
            },
            child: const Text('Google 로그인'),
          ),
        ],
      ),
    );
  }

  void FlutterDialogInvaild() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: const <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('이메일이 확인되지 않았습니다!'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void FlutterDialogRegister() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: const <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('등록되지 않은 이메일입니다.'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void FlutterDialogPassword() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: const <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('비밀번호가 틀렸습니다.'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
