import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateBookViewModel {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future uploadImage(String fileName, Uint8List bytes) async {
    final storageRef = _storage.ref().child('book_cover/$fileName.jpg');
    await storageRef.putData(bytes);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future updateBook(
      {required DocumentSnapshot document,
      required String title,
      required String author,
      required Uint8List? bytes}) async {
    if (title.isNotEmpty && author.isNotEmpty && bytes == null) {
      await _db.collection('books').doc(document.id).update({
        "title": title,
        "author": author,
      });
    } else if (title.isNotEmpty && author.isNotEmpty && bytes != null) {
      String downloadUrl = await uploadImage(document.id, bytes);
      await _db.collection('books').doc(document.id).update({
        "title": title,
        "author": author,
        "imageUrl": downloadUrl,
      });
    } else if (author.isEmpty && title.isEmpty) {
      return Future.error('제목과 저자를 입력해 주세요');
    } else if (author.isEmpty) {
      return Future.error('저자를 입력해 주세요');
    } else if (title.isEmpty) {
      return Future.error('제목을 입력해 주세요');
    }
  }
}
