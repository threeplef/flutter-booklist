import 'package:cloud_firestore/cloud_firestore.dart';

class BookListViewModel {
  final _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get booksStream => _db.collection('books').snapshots();

  Future deleteBook({required DocumentSnapshot document}) async {
    await _db.collection('books').doc(document.id).delete();
  }
}
