import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookViewModel {
  final _db = FirebaseFirestore.instance;

  Future addBook({required String title, required String author}) async {
    await _db.collection('books').add({
      "title": title,
      "author": author,
    });
  }
}
