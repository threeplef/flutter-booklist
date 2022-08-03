import 'package:flutter/material.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 관리 앱'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('flutter 생존코딩'),
            subtitle: Text('오준석'),
          ),
          ListTile(
            title: Text('flutter 생존코딩2'),
            subtitle: Text('오준석'),
          ),
          ListTile(
            title: Text('flutter 생존코딩3'),
            subtitle: Text('오준석'),
          ),
        ],
      ),
    );
  }
}
