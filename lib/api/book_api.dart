import 'dart:convert';

import 'package:book_app/api/book_api_interface.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/repository/sqlite_service.dart';
import 'package:http/http.dart' as http;
import '../assets/constants.dart' as constants;
import '../models/response_model.dart';

class BookApi implements BookApiInterface{
var _db = SqliteService();
@override
  Future<ResponseModel<List<Book>>> fetchBooks(String title) async {
  final response = await http
      .get(Uri.parse(constants.getByTitleURL+title));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);

    List<Book> books = [];

    if(body['totalItems'] == 0) return ResponseModel.error(false, "Book could not found!");

    final items = body['items'];
    for (var item in items){
      var book = Book.fromJson(item);

      if(await isBookFavorite(book.id!)){
        book.isFavorite = true;
      }
      
      books.add(book);
    }
    return ResponseModel.succes(books, true);
  } else {
    // throw Exception('Failed to load book!');
    return ResponseModel.error(false, "Failed to load book!");
  }
}

Future<bool> isBookFavorite(String bookId) async {
  var result = await _db.db.query("Favorites", columns: ["id"], where: 'id = ?', whereArgs: [bookId]);
  return result.toList().isNotEmpty;
}
 
}