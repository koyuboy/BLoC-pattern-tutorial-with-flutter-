import '../models/book.dart';
import '../models/response_model.dart';

abstract class BookApiInterface{
  Future<ResponseModel<List<Book>>> fetchBooks(String title);
}