import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/components/grid_view_widget.dart';
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
            GridViewWidget(books: _books),
          ],
        ),
      ),
    );
  }
}
