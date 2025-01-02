import 'package:http/http.dart' as http;
import 'package:pd24_book_tracker_app/models/book.dart';
import 'dart:convert';

class Network {
  // https://www.googleapis.com/books/v1/volumes?q=flutter
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<void> searchBooks(String query) async {
    var url = Uri.parse('$_baseUrl?q=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
