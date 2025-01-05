import 'package:flutter/material.dart';
import 'package:pd24_book_tracker_app/db/database_helper.dart';
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
    final TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (book.imageLinks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  book.imageLinks['thumbnail'] ?? '',
                  height: 300,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              book.title,
              style: theme.headlineSmall,
            ),
            Text(
              book.authors.join(', '),
              style: theme.labelLarge,
            ),
            Text(
              'Published: ${book.publishedDate}',
              style: theme.bodySmall,
            ),
            Text(
              'Page Count: ${book.pageCount}',
              style: theme.bodySmall,
            ),
            Text(
              'Language: ${book.language}',
              style: theme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      try {
                        DatabaseHelper databaseHelper = DatabaseHelper();
                        int savedIndex = await databaseHelper.insert(book);
                        print('Saved book at index: $savedIndex');
                        SnackBar snackBar = SnackBar(
                          content: Text('Book saved at index: $savedIndex'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        print('Error saving book: $e');
                        SnackBar snackBar = SnackBar(
                          content: Text('Error saving book: $e'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('Save')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        DatabaseHelper databaseHelper = DatabaseHelper();
                        await databaseHelper.deleteAllBooks();
                        print('Deleted all books');
                        SnackBar snackBar = SnackBar(
                          content: const Text('All books deleted'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        print('Error deleting all books: $e');
                        SnackBar snackBar = SnackBar(
                          content: Text('Error deleting all books: $e'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('Delete All Books')),
                ElevatedButton.icon(
                  onPressed: () async {},
                  icon: const Icon(Icons.favorite),
                  label: const Text('Favorite'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: theme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                book.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
