import 'package:aaaaaaaaa/DB/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// userテーブルのカラム名を設定
const String columnId = '_id';
const String columnName = 'name';

// userテーブルのカラム名をListに設定
const List<String> columns = [
  columnId,
  columnName,
];

// userテーブルへのアクセスをまとめたクラス
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
    String path = join(await getDatabasesPath(), 'zettai.db');    // user.dbのパスを取得する

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,      // user.dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  // データベースがなかった時の処理
  Future _onCreate(Database database, int version) async {
    //userテーブルをcreateする
    await database.execute('''
      CREATE TABLE user(
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
  }

  // userテーブルのデータを全件取得する
  Future<List<User>> selectAllUser() async {
    final db = await instance.database;
    final userData = await db.query('user');          // 条件指定しないでuserテーブルを読み込む

    return userData.map((json) => User.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  }

// _idをキーにして1件のデータを読み込む
  Future<User> userData(int id) async {
    final db = await instance.database;
    var user = [];
    user = await db.query(
      'user',
      columns: columns,
      where: '_id = ?',                     // 渡されたidをキーにしてuserテーブルを読み込む
      whereArgs: [id],
    );
    return User.fromJson(user.first);      // 1件だけなので.toListは不要
  }

// データをinsertする
  Future insert(User user) async {
    final db = await database;
    return await db.insert(
        'user',
        user.toJson()                         // user.dartで定義しているtoJson()で渡されたuserをパースして書き込む
    );
  }

// データをupdateする
  Future update(User user) async {
    final db = await database;
    return await db.update(
      'user',
      user.toJson(),
      where: '_id = ?',                   // idで指定されたデータを更新する
      whereArgs: [user.id],
    );
  }

// データを削除する
  Future delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'user',
      where: '_id = ?',                   // idで指定されたデータを削除する
      whereArgs: [id],
    );
  }
}