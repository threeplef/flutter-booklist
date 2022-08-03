import 'package:cloud_firestore/cloud_firestore.dart';

class BookListViewModel {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get booksStream => db.collection('books').snapshots();
}