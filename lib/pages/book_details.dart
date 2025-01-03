import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/models/book.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key, this.book});

  final Book? book;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Center(
        child: Column(
          children: const [
            Text('Book Details'),
          ],
        ),
      ),
    );
  }
}
