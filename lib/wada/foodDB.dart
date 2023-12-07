/*
import 'food.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// foodテーブルのカラム名を設定
const String columnId = '_id';
const String columnName = 'name';

// foodテーブルのカラム名をListに設定
const List<String> columns = [
  columnId,
  columnName,
];

// foodテーブルへのアクセスをまとめたクラス
class DbHelper {
  // DbHelperをinstance化する
  static final DbHelper instance = DbHelper._createInstance();
  static Database? _database;

  DbHelper._createInstance();

  // databaseをオープンしてインスタンス化する
  Future<Database> get database async {
    return _database ??= await _initDB();       // 初回だったら_initDB()=DBオープンする
  }

  // データベースをオープンする
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'food.db');    // food.dbのパスを取得する

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,      // food.dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  // データベースがなかった時の処理
  Future _onCreate(Database database, int version) async {
    //foodテーブルをcreateする
    await database.execute('''
      CREATE TABLE food(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');


    // foodテーブルのデータを全件取得する
    Future<List<Food>> selectAllUser() async {
      final db = await instance.database;
      final userData = await db.query('user');          // 条件指定しないでfoodテーブルを読み込む

      return userData.map((json) => Food.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
    }

// _idをキーにして1件のデータを読み込む
    Future<Food> foodData(int id) async {
      final db = await instance.database;
      var food = [];
      food = await db.query(
        'user',
        columns: columns,
        where: '_id = ?',                     // 渡されたidをキーにしてfoodテーブルを読み込む
        whereArgs: [id],
      );
      return Food.fromJson(food.first);      // 1件だけなので.toListは不要
    }

// データをinsertする
    Future insert(Food food) async {
      final db = await database;
      return await db.insert(
          'food',
          food.toJson()                         // food.dartで定義しているtoJson()で渡されたfoodをパースして書き込む
      );
    }

// データをupdateする
    Future update(Food food) async {
      final db = await database;
      return await db.update(
        'food',
        food.toJson(),
        where: '_id = ?',                   // idで指定されたデータを更新する
        whereArgs: [food.id],
      );
    }

// データを削除する
    Future delete(int id) async {
      final db = await instance.database;
      return await db.delete(
        'food',
        where: '_id = ?',                   // idで指定されたデータを削除する
        whereArgs: [id],
      );
    }
  }
}

 */