import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/models/book.dart';
import 'package:pd24_book_tracker_app/network/network.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Network _network = Network();
  List<Book> _books = [];

  Future<void> _searchBooks(String query) async {
    try {
      List<Book> books = await _network.searchBooks(query);
      // print('Books: ${books.toString()}');

      setState(() {
        _books = books;
      });
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (query) {
                  _searchBooks(query);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: 'Search for books',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.5,
                ),
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  Book book = _books[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            book.imageLinks['thumbnail'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            book.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            book.authors.join(', '),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ListView.builder(
            //       itemCount: _books.length,
            //       itemBuilder: (context, index) {
            //         Book book = _books[index];
            //         return ListTile(
            //           title: Text(book.title),
            //           subtitle: Text(
            //             book.authors.join(', '),
            //           ),
            //           leading:
            //               Image.network(book.imageLinks['thumbnail'] ?? ''),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
