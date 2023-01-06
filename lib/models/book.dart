import '../assets/constants.dart' as constants;
import 'model.dart';
class Book extends Model{
  String? id;
  String title;
  String? subTitle;
  String? publisher;
  String? publishedDate; 
  int? pageCount;
  String thumbnail;
  String? authors;
  String? description;
  bool isFavorite;

  Book({required String this.id, required String this.title, String?  this.subTitle, String? this.publisher, String? this.publishedDate, int? this.pageCount, required String this.thumbnail, String? this.authors, String? this.description, bool this.isFavorite=false});

  factory Book.fromJson(Map<String, dynamic> json) {
    String getAuthors(Map<String, dynamic> json){
    if(json['authors'] == null) return "";
    var list = json['authors'];

    if(list.isEmpty){
      return "";
    }
    String authors="";
    for(var a in list){
      if(authors!="") authors+=", ";
      authors+=a;
    }
    return authors;
  }
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title']??"Bilinmiyor",
      subTitle: json['volumeInfo']['subtitle']??"",
      publisher: json['volumeInfo']['publisher']??"",
      publishedDate: json['volumeInfo']['publishedDate']??"",
      pageCount: json['volumeInfo']['pageCount'],
      thumbnail: json['volumeInfo']['imageLinks']?['thumbnail']??constants.defaultBookThumbnail,
      authors: getAuthors(json['volumeInfo']),
      description: json['volumeInfo']['description']??""
    );
  }

  
} 