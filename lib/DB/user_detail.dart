import 'package:aaaaaaaaa/DB/db_helper.dart';
import 'package:aaaaaaaaa/DB/user.dart';
import 'package:aaaaaaaaa/DB/user_detail_edit.dart';
import 'package:flutter/material.dart';


// catsテーブルの中の1件のデータに対する操作を行うクラス
class UserDetail extends StatefulWidget {
  final int id;

  const UserDetail({Key? key, required this.id}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late User user;
  bool isLoading = false;
  static const int textExpandedFlex = 1; // 見出しのexpaded flexの比率
  static const int dataExpandedFlex = 4; // 項目のexpanede flexの比率


// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、渡されたidをキーとしてcatsテーブルからデータを取得する
  @override
  void initState() {
    super.initState();
    userData();
  }

// initStateで動かす処理
// userテーブルから指定されたidのデータを1件取得する
  Future userData() async {
    setState(() => isLoading = true);
    user = await DbHelper.instance.userData(widget.id);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ユーザ詳細'),
          actions: [
            IconButton(
              onPressed: () async {                          // 鉛筆のアイコンが押されたときの処理を設定
                await Navigator.of(context).push(            // ページ遷移をNavigatorで設定
                  MaterialPageRoute(
                    builder: (context) => UserDetailEdit(    // 詳細更新画面を表示する
                      user: user,
                    ),
                  ),
                );
                userData();                                  // 更新後のデータを読み込む
              },
              icon: const Icon(Icons.edit),                 // 鉛筆マークのアイコンを表示
            ),
            IconButton(
              onPressed: () async {                         // ゴミ箱のアイコンが押されたときの処理を設定
                await DbHelper.instance.delete(widget.id);  // 指定されたidのデータを削除する
                Navigator.of(context).pop();                // 削除後に前の画面に戻る
              },
              icon: const Icon(Icons.delete),               // ゴミ箱マークのアイコンを表示
            )
          ],
        ),
        body: isLoading                                     //「読み込み中」だったら「グルグル」が表示される
            ? const Center(
          child: CircularProgressIndicator(),         // これが「グルグル」の処理
        )
            : Column(
          children :[
            Container(                      // アイコンを表示
                width: 80,height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,     // 丸にする
                )
            ),
            Column(                                             // 縦並びで項目を表示
              crossAxisAlignment: CrossAxisAlignment.stretch,   // 子要素の高さを合わせる
              children: [
                Row(children: [
                  const Expanded(                               // 見出しの設定
                    flex: textExpandedFlex,
                    child: Text('ユーザ名',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                           // userテーブルのnameの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(user.name),
                    ),
                  ),
                ],),
              ],
            ),
          ],
        )
    );
  }
}