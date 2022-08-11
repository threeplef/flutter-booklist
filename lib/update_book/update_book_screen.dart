import 'dart:typed_data';

import 'package:book_list_app/update_book/update_book_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateBookScreen extends StatefulWidget {
  final DocumentSnapshot document;

  const UpdateBookScreen(this.document, {Key? key}) : super(key: key);

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();

  final viewModel = UpdateBookViewModel();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _bytes;

  @override
  void dispose() {
    _titleTextController.dispose();
    _authorTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFFEC60),
        title: const Text('수정', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFDFAF3),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        // byte array
                        _bytes = await image.readAsBytes();

                        setState(() {});
                      }
                    },
                    child: SizedBox(
                      width: 200,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _bytes == null
                              ? Image.network(widget.document['imageUrl'],
                                  fit: BoxFit.cover)
                              : Image.memory(_bytes!, fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: TextField(
                    controller: _titleTextController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFA351F7), width: 1.0)),
                      hintText: widget.document['title'],
                      contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                      isCollapsed: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: TextField(
                    controller: _authorTextController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFA351F7), width: 1.0)),
                      hintText: widget.document['author'],
                      contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                      isCollapsed: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 340,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel
                          .updateBook(
                            document: widget.document,
                            title: _titleTextController.text,
                            author: _authorTextController.text,
                            bytes: _bytes,
                          )
                          .then((_) => Navigator.pop(context))
                          .catchError((e) {
                        // 에러가 났을 때
                        final snackBar = SnackBar(
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFFFEC60),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: const Text(
                      '도서 수정',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA351F7)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
