import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/db/database_helper.dart';
import 'package:pd24_book_tracker_app/models/book.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      // get favorite items from the database using FutureBuilder
      body: FutureBuilder<List<Book>>(
        future: DatabaseHelper().getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading favorites: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Book> favBooks = snapshot.data!;
            return ListView.builder(
              itemCount: favBooks.length,
              itemBuilder: (context, index) {
                Book book = favBooks[index];
                return Card(
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.authors.join(', ')),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () async {
                        try {
                          print(book.isFavorite);
                          DatabaseHelper databaseHelper = DatabaseHelper();
                          int updated = await databaseHelper
                              .toggleFavoriteStatus(book.id, false);
                          print('Updated: $updated');
                          setState(() {});
                        } catch (e) {
                          print('Error reading all books: $e');
                        }
                      },
                    ),
                    leading: Image.network(
                      book.imageLinks['thumbnail'] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No favorites yet!'),
            );
          }
        },
      ),
    );
  }
}
