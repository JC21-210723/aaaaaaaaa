/*
import 'foodDB';
// Foodテーブルの定義
class Food {
  late int? id;
  late String name;

  Food({
    this.id,
    required this.name,
  });

  //ok
// 更新時のデータを入力項目からコピーする処理
  Food copy({
    int? id,
    String? name,
  }) =>
      Food(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static Food fromJson(Map<String, Object?> json) => Food(
    id: json[columnId] as int,
    name: json[columnName] as String,
  );

  Map<String, Object> toJson() => {
    columnName: name,
  };
}
 */