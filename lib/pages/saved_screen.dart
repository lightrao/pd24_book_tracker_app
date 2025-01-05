import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/db/database_helper.dart';
import 'package:pd24_book_tracker_app/models/book.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Saved In SQLite Database'),
      ),
      // get all items from the database using FutureBuilder
      // some useful code snippets are provided below:
      // DatabaseHelper databaseHelper = DatabaseHelper();
      // List<Book> books = await databaseHelper.readAllBooks();
      body: FutureBuilder<List<Book>>(
        future: DatabaseHelper().readAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.authors.join(', ')),
                  leading: Image.network(
                    book.imageLinks['thumbnail'] ?? '',
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    // navigate to the book details screen
                    // some useful code snippets are provided below:
                    // Navigator.pushNamed(context, '/book_details',
                    //     arguments: BookDetailsArguments(itemBook: book));
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('No books saved in the database'),
            );
          }
        },
      ),
    );
  }
}
