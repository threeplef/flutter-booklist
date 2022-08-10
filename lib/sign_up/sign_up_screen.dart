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
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFFEC60),
        title: const Text('회원가입', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFDFAF3),
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                  child: Text('하늘의 서재에 오신 것을 환영합니다! \n마음에 드는 다양한 책을 읽고 기록해보세요.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
                Image.network(
                    'https://www.millie.co.kr/favicon/millie_og_v2_2.png',
                    width: 360),
                const SizedBox(height: 15),
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
                            borderSide: BorderSide(
                                color: Color(0xFFA351F7), width: 1.0)),
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
                            borderSide: BorderSide(
                                color: Color(0xFFA351F7), width: 1.0)),
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
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text);
                            if (userCredential.user!.email == null) {
                            } else {
                              Navigator.pop(context);
                            }
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            flutterDialog('비밀번호가 너무 약합니다. 6자 이상의 비밀번호를 입력해주세요.');
                          } else if (e.code == 'email-already-in-use') {
                            flutterDialog('이미 사용 중인 이메일입니다.');
                          }
                        } catch (e) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFFFEC60),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: const Text('회원가입',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA351F7)))),
                )
              ],
            ),
          ),
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
                Text(message),
              ],
            ),
            actions: <Widget>[
              TextButton(
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
