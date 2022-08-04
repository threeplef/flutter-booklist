import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBookViewModel {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future uploadImage(String fileName, Uint8List bytes) async {
    final storageRef = _storage.ref().child('book_cover/$fileName.jpg');
    await storageRef.putData(bytes);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future addBook(
      {required String title,
      required String author,
      required Uint8List? bytes}) async {

    // 빈 문서 (ID 미리 얻을 때)
    final doc = _db.collection('books').doc();
    // 이미지 업로드하고 다운로드 URL 얻기
    String downloadUrl = await uploadImage(doc.id, bytes!);
    // 문서 덮어쓰기
    await _db.collection('books').doc(doc.id).set({
      "title": title,
      "author": author,
      "imageUrl": downloadUrl,
    });
  }

  bool isValid(String title, String author) {
    return title.isEmpty || author.isEmpty;
  }
}
