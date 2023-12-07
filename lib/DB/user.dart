import 'db_helper.dart';
import 'package:intl/intl.dart';

// Userテーブルの定義
class User {
  int? id;
  String name;

  User({
    this.id,
    required this.name,
  });

  //ok
// 更新時のデータを入力項目からコピーする処理
  User copy({
    int? id,
    String? name,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static User fromJson(Map<String, Object?> json) => User(
    id: json[columnId] as int,
    name: json[columnName] as String,
  );

  Map<String, Object> toJson() => {
    columnName: name,
  };
}