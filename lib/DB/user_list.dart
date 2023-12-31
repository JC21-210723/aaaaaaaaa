import 'package:aaaaaaaaa/DB/db_helper.dart';
import 'package:aaaaaaaaa/DB/user.dart';
import 'package:aaaaaaaaa/DB/user_detail.dart';
import 'package:aaaaaaaaa/DB/user_detail_edit.dart';
import 'package:flutter/material.dart';


// catテーブルの内容全件を一覧表示するクラス
class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserList> {
  List<User> userList = [];  //userテーブルの全件を保有する
  bool isLoading = false;   //テーブル読み込み中の状態を保有する

// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、初期処理としてUserの全データを取得する。
  @override
  void initState() {
    super.initState();
    getUserList();
  }

// initStateで動かす処理。
// userテーブルに登録されている全データを取ってくる
  Future getUserList() async {
    setState(() => isLoading = true);                   //テーブル読み込み前に「読み込み中」の状態にする
    userList = await DbHelper.instance.selectAllUser();  //userテーブルを全件読み込む
    setState(() => isLoading = false);                  //「読み込み済」の状態にする
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ユーザ一覧')),
      body: isLoading                               //「読み込み中」だったら「グルグル」が表示される
          ? const Center(
        child: CircularProgressIndicator(),   // これが「グルグル」の処理
      )
          : SizedBox(
        child: ListView.builder(              // 取得したuserテーブル全件をリスト表示する
          itemCount: userList.length,          // 取得したデータの件数を取得
          itemBuilder: (BuildContext context, int index) {
            final user = userList[index];       // 1件分のデータをuserに取り出す
            return Card(                      // ここで1件分のデータを表示
              child: InkWell(                 // cardをtapしたときにそのcardの詳細画面に遷移させる
                child: Padding(               // cardのpadding設定
                  padding: const EdgeInsets.all(15.0),
                  child: Row(                 // cardの中身をRowで設定
                      children: <Widget>[               // Rowの中身を設定
                        Container(                      // アイコンを表示
                            width: 80,height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,     // 丸にする

                            )
                        ),
                        Text(user.name,style: const TextStyle(fontSize: 30),),     // userのnameを表示
                      ]
                  ),
                ),
                onTap: () async {                     // cardをtapしたときの処理を設定
                  await Navigator.of(context).push(   // ページ遷移をNavigatorで設定
                    MaterialPageRoute(
                      builder: (context) => UserDetail(id: user.id!),   // cardのデータの詳細を表示するcat_detail.dartへ遷移
                    ),
                  );
                  getUserList();    // データが更新されているかもしれないので、catsテーブル全件読み直し
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(                   // ＋ボタンを下に表示する
        child: const Icon(Icons.add),                               // ボタンの形を指定
        onPressed: () async {                                       // ＋ボタンを押したときの処理を設定
          await Navigator.of(context).push(                         // ページ遷移をNavigatorで設定
            MaterialPageRoute(
                builder: (context) => const UserDetailEdit()           // 詳細更新画面（元ネタがないから新規登録）を表示するcat_detail_edit.dartへ遷移
            ),
          );
          getUserList();                                            // 新規登録されているので、catテーブル全件読み直し
        },
      ),
    );
  }
}