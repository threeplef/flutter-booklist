import 'package:book_list_app/add_book/add_book_screen.dart';
import 'package:book_list_app/book_list/book_list_view_model.dart';
import 'package:book_list_app/model/book.dart';
import 'package:book_list_app/update_book/update_book_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BookListScreen extends StatelessWidget {
  BookListScreen({Key? key}) : super(key: key);

  final viewModel = BookListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFEC60),
        title: const Center(
          child: Text('내 도서 리스트', style: TextStyle(color: Colors.black)),
        ),
      ),
      body: Container(
        color: const Color(0xFFFDFAF3),
        child: StreamBuilder<QuerySnapshot<Book>>(
            stream: viewModel.booksStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Book book = document.data()! as Book;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image.network(
                        book.imageUrl,
                        width: 70,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(book.title),
                          const SizedBox(height: 3),
                          Text(book.author, style: const TextStyle(fontSize: 14, color: Colors.black54),),
                        ],
                      ),
                      visualDensity: const VisualDensity(vertical: 4),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateBookScreen(document)),
                        );
                      },
                      trailing: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.delete),
                        highlightColor: const Color(0x66A351F7),
                        onPressed: () {
                          BookListViewModel().deleteBook(document: document);
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.person,
        backgroundColor: const Color(0xFFFFEC60),
        foregroundColor: const Color(0xFFA351F7),
        elevation: 0,
        spacing: 5,
        spaceBetweenChildren: 5,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.add),
              label: '도서 추가',
              backgroundColor: const Color(0xFFFFEC60),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddBookScreen()),
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.logout),
              label: '로그아웃',
              backgroundColor: const Color(0xFFFFEC60),
              onTap: () {
                viewModel.logout();
              }),
        ],
      ),
    );
  }
}
