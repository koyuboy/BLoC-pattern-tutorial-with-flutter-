import 'package:sqflite/sqflite.dart';

class SqliteService {
  late var db;
  
  SqliteService(){
    createDatabase();
  }
  void createDatabase() async {
      String databasesPath = await getDatabasesPath();
      String dbPath = '${databasesPath}my.db';

      var database =
          await openDatabase(dbPath, version: 1, onCreate: populateDb);
      db = database;
    }
  void populateDb(Database database, int version) async {
      await database.execute("CREATE TABLE Favorites (id TEXT PRIMARY KEY)");
    }
}
