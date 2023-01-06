import 'dart:async';

import 'package:book_app/models/book.dart';
import 'package:book_app/models/response_model.dart';
import 'package:tuple/tuple.dart';

import '../api/book_api.dart';
import '../repository/sqlite_service.dart';

enum BookAction { fetchByTitle, getFavorites, addFavorite, removeFavorite }

class BookBloc {
  final _bookApi = BookApi();
  final _db = SqliteService();

  final _stateStreamController = StreamController<ResponseModel<List<Book>>>();
  StreamSink<ResponseModel<List<Book>>> get _bookSink =>
      _stateStreamController.sink;
  Stream<ResponseModel<List<Book>>> get bookStream =>
      _stateStreamController.stream;

  final _eventStreamController =
      StreamController<Tuple2<BookAction, String?>>();
  StreamSink<Tuple2<BookAction, String?>> get eventSink =>
      _eventStreamController.sink;
  Stream<Tuple2<BookAction, String?>> get _eventStream =>
      _eventStreamController.stream;

  BookBloc() {
    _eventStream.listen((event) async {
      if (event.item1 == BookAction.fetchByTitle) {
        //! fetch books
        event.item2!.trim();
        if (event.item2!.isEmpty ||
            event.item2!.startsWith(" ") ||
            event.item2!.endsWith(" ")) return;
        var books = await _bookApi.fetchBooks(event.item2!);

        if (event.item2!.length > 500) {
          _bookSink.add(ResponseModel.error(
              false, "The search term cannot be longer than 500 characters."));
        }
        _bookSink.add(books);
      } else if (event.item1 == BookAction.addFavorite) {
                                              //! add favorite
        addTofavorite(event.item2!);
      } else if (event.item1 == BookAction.removeFavorite) {
                                              //! remove favorite
        removeFromFavorite(event.item2!);
      } else if (event.item1 == BookAction.getFavorites) {
        //! get favorite

      }
    });
  }

  Future<void> addTofavorite(String bookId) async {
    await _db.db.insert("Favorites", {"id": bookId});
  }

  Future<int> removeFromFavorite(String bookId) async {
  return await _db.db.delete("Favorites", where: 'id = ?', whereArgs: [bookId]);
}
}
