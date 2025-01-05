import 'package:pd24_book_tracker_app/models/book.dart';

class BookDetailsArguments {
  final Book itemBook;
  final bool isFromSavedScreen;

  BookDetailsArguments(
      {required this.itemBook, required this.isFromSavedScreen});
}
