import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBookViewModel {
  final _db = FirebaseFirestore.instance;

  Future updateBook({required DocumentSnapshot document, required String title, required String author}) async {
    await _db.collection('books').doc(document.id).update({
      "title": title,
      "author": author,
    });
  }
}