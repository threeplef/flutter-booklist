import 'dart:typed_data';

import 'package:book_list_app/add_book/add_book_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();

  final viewModel = AddBookViewModel();

  final ImagePicker _picker = ImagePicker();

  // byte array
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
        title: const Text('도서 추가', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFDFAF3),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          // byte array
                          _bytes = await image.readAsBytes();

                          setState(() {});
                        }
                      },
                      child: _bytes == null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12,
                              ),
                              width: 200,
                              height: 250,
                              child: const Icon(Icons.image),
                            )
                          : Image.memory(_bytes!, width: 200, height: 200),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          onChanged: (_) {
                            setState(() {});
                          },
                          controller: _titleTextController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFA351F7), width: 1.0)),
                            hintText: '제목',
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
                          onChanged: (_) {
                            setState(() {});
                          },
                          controller: _authorTextController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFA351F7), width: 1.0)),
                            hintText: '저자',
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                            isCollapsed: true,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 340,
                      height: 45,
                      child: viewModel.isInvalid(
                        _titleTextController.text,
                        _authorTextController.text,
                      )
                          ? ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              child: const Text(
                                '도서 추가',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  viewModel.startLoading();
                                });
                                await viewModel.addBook(
                                  title: _titleTextController.text,
                                  author: _authorTextController.text,
                                  bytes: _bytes,
                                );
                                setState(() {
                                  viewModel.endLoading();
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFFFEC60),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              child: const Text(
                                '도서 추가',
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
            if (viewModel.isLoading)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              )
          ],
        ),
      ),
    );
  }
}
