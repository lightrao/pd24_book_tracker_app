import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/db/database_helper.dart';
import 'package:pd24_book_tracker_app/models/book.dart';
import 'package:pd24_book_tracker_app/utils/book_details_arguments.dart';

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
                print('Book: $book');
                return Card(
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Column(
                      children: [
                        Text(book.authors.join(', ')),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              book.isFavorite = !book.isFavorite;
                              DatabaseHelper databaseHelper = DatabaseHelper();
                              int updated =
                                  await databaseHelper.toggleFavoriteStatus(
                                      book.id, book.isFavorite);
                              setState(() {});
                              print('Updated: $updated');
                            } catch (e) {
                              print('Error reading all books: $e');
                            }
                          },
                          icon: Icon(
                            book.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: book.isFavorite ? Colors.red : null,
                          ),
                          label: Text(book.isFavorite
                              ? 'Remove from favorites'
                              : 'Add to favorites'),
                        ),
                      ],
                    ),
                    leading: Image.network(
                      book.imageLinks['thumbnail'] ?? '',
                      fit: BoxFit.cover,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // delete the book from the database
                        DatabaseHelper databaseHelper = DatabaseHelper();
                        databaseHelper.deleteBook(book.id);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      // navigate to the book details screen
                      Navigator.pushNamed(context, '/book_details',
                          arguments: BookDetailsArguments(
                              itemBook: book, isFromSavedScreen: true));
                    },
                  ),
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
