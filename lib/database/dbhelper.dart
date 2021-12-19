import 'dart:async';
import 'dart:io' as io;
import 'dart:ui';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wine_diary/model/wine.dart';

class DBHelper {
  static late Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Wines(id INTEGER PRIMARY KEY, name TEXT, description TEXT, year TEXT, review TEXT, image BLOB )");
    print("Created tables");
  }

  void saveWine(Wine wine) async {
    var dbClient = await db;
    String wine_name = wine.name ?? "";
    String  wine_description = wine.description ?? "";
    int wine_year = wine.year ?? new DateTime.now().year;
    String  wine_review = wine.review ?? "";
    Image wine_img = wine.img ?? new Image();
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Wines(name, description, year, review, img) VALUES(' +
              '\'' +
              wine_name +
              '\'' +
              ',' +
              '\'' +
              wine_description +
              '\'' +
              ',' +
              '\'' +
              wine_year +
              '\'' +
              ',' +
              '\'' +
              wine_review +
              '\'' +
              ',' +
              '\'' +

              wine_img +
              '\'' +
              ')');
    });
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["firstname"], list[i]["lastname"], list[i]["mobileno"], list[i]["emailid"]));
    }
    print(employees.length);
    return employees;
  }
}