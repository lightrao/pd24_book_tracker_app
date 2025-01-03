import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/models/book.dart';
import 'package:pd24_book_tracker_app/utils/book_details_arguments.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    final BookDetailsArguments bookDetailsArguments =
        ModalRoute.of(context)?.settings.arguments as BookDetailsArguments;
    final Book book = bookDetailsArguments.itemBook;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
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
