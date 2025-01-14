import 'package:path/path.dart';
import 'package:pd24_book_tracker_app/models/book.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'book_database.db';
  static const _databaseVersion = 2;
  static const _tableName = 'books';
  static Database? _database;
  // Corrected static instance initialization
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> _getDatabase() async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create the books table
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        authors TEXT NOT NULL,
        favorite INTEGER DEFAULT 0,
        publisher TEXT,
        publishedDate TEXT,
        description TEXT,
        industryIdentifiers TEXT,
        pageCount INTEGER,
        language TEXT,
        imageLinks TEXT,
        previewLink TEXT,
        infoLink TEXT
      )
    ''');
  }

  Future<int> insert(Book book) async {
    Database db = await _instance._getDatabase();
    return await db.insert(_tableName, book.toJson());
  }

  Future<List<Book>> readAllBooks() async {
    Database db = await _instance._getDatabase();
    var books = await db.query(_tableName);
    return books.isNotEmpty
        ? books.map((bookData) => Book.fromJsonDatabase(bookData)).toList()
        : [];
  }

  Future<int> toggleFavoriteStatus(String id, bool isFavorite) async {
    Database db = await _instance._getDatabase();
    return await db.update(_tableName, {'favorite': isFavorite ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBook(String id) async {
    Database db = await _instance._getDatabase();
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // delete all books
  Future<int> deleteAllBooks() async {
    Database db = await _instance._getDatabase();
    return await db.delete(_tableName);
  }

  // Get favorite books
  Future<List<Book>> getFavorites() async {
    Database db = await _instance._getDatabase();
    var favBooks =
        await db.query(_tableName, where: 'favorite = ?', whereArgs: [1]);

    return favBooks.isNotEmpty
        ? favBooks.map((bookData) => Book.fromJsonDatabase(bookData)).toList()
        : [];
  }
}
