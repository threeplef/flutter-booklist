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
        backgroundColor: const Color(0xFFFFEC60),
        title: const Center(
            child: Text(
          '로그인',
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: Container(
        color: const Color(0xFFFDFAF3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                'http://cdn.iconsumer.or.kr/news/photo/201910/10199_12763_28.png',
                width: 100),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFA351F7), width: 1.0)),
                    hintText: '이메일',
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                    isCollapsed: true,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFA351F7), width: 1.0)),
                    hintText: '패스워드',
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                    isCollapsed: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 340,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text);

                    if (userCredential.user!.emailVerified == true) {
                    } else {
                      flutterDialog('이메일이 확인되지 않았습니다.');
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      flutterDialog('등록되지 않은 이메일입니다.');
                    } else if (e.code == 'wrong-password') {
                      flutterDialog('비밀번호가 다릅니다.');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFFFEC60),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA351F7)),
                ),
              ),
            ),
            SizedBox(
              width: 340,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                style: TextButton.styleFrom(
                    primary: const Color(0xFFFFEC60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: const Text('회원가입',
                    style: TextStyle(fontSize: 15, color: Color(0xFFA351F7))),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 340,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  viewModel.signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    side: const BorderSide(width: 1.0, color: Colors.black12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png',
                        width: 25),
                    const SizedBox(width: 7),
                    const Text(
                      'Google로 로그인',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void flutterDialog(String message) {
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
              children: <Widget>[
                Center(child: Text(message)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Center(child: Text('확인')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
