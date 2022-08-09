import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

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
        title: const Text('회원 가입'),
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
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '패스워드',
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    if (value.user!.email == null) {
                    } else {
                      Navigator.pop(context);
                    }
                    return value;
                  });
                  FirebaseAuth.instance.currentUser?.sendEmailVerification();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    FlutterDialogPassword();
                  } else if (e.code == 'email-already-in-use') {
                    FlutterDialogAlreadyUsed();
                  }
                } catch (e) {
                  Navigator.pop(context);
                }
              },
              child: const Text('회원가입'))
        ],
      ),
    );
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
                Text('비밀번호 보안이 너무 약합니다. 영문, 숫자, 기호를 포함한 8자리를 입력해주세요.'),
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

  void FlutterDialogAlreadyUsed() {
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
                Text('이미 사용 중인 이메일입니다.'),
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
