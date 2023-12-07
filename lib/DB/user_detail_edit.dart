import 'package:aaaaaaaaa/DB/db_helper.dart';
import 'package:aaaaaaaaa/DB/user.dart';
import 'package:flutter/material.dart';


class UserDetailEdit extends StatefulWidget {
  final User? user;

  const UserDetailEdit({Key? key, this.user}) : super(key: key);

  @override
  _UserDetailEditState createState() => _UserDetailEditState();
}

class _UserDetailEditState extends State<UserDetailEdit> {
  late int id;
  late String name;
  static const int textExpandedFlex = 1; // 見出しのexpaded flexの比率
  static const int dataExpandedFlex = 4; // 項目のexpanede flexの比率

// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、各項目の初期値を設定する
  @override
  void initState() {
    super.initState();
    id = widget.user?.id ?? 0;
    name = widget.user?.name ?? '';
  }

// 詳細編集画面を表示する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザ編集'),
        actions: [
          buildSaveButton(), // 保存ボタンを表示する
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Row(children: [
            // 名前の行の設定
            const Expanded(                   // 見出し（名前）
              flex: textExpandedFlex,
              child: Text('ユーザ名',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(                         // 名前入力エリアの設定
              flex: dataExpandedFlex,
              child: TextFormField(
                maxLines: 1,
                initialValue: name,
                decoration: const InputDecoration(
                  hintText: 'ユーザ名を入力してください',
                ),
                validator: (name) => name != null && name.isEmpty
                    ? '名前は必ず入れてね'
                    : null, // validateを設定
                onChanged: (name) => setState(() => this.name = name),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

// 保存ボタンの設定
  Widget buildSaveButton() {
    final isFormValid = name.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: const Text('保存'),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.redAccent : Colors.grey.shade700,
        ),
        onPressed: createOrUpdateUser, // 保存ボタンを押したら実行する処理を指定する
      ),
    );
  }

// 保存ボタンを押したとき実行する処理
  void createOrUpdateUser() async {
    final isUpdate = (widget.user != null);     // 画面が空でなかったら

    if (isUpdate) {
      await updateUser();                        // updateの処理
    } else {
      await createUser();                        // insertの処理
    }

    Navigator.of(context).pop();                // 前の画面に戻る
  }

  // 更新処理の呼び出し
  Future updateUser() async {
    final user = widget.user!.copy(              // 画面の内容をuserにセット
      name: name,
    );

    await DbHelper.instance.update(user);        // userの内容で更新する
  }

  // 追加処理の呼び出し
  Future createUser() async {
    final user = User(                           // 入力された内容をuserにセット
      name: name,
    );
    await DbHelper.instance.insert(user);        // userの内容で追加する
  }
}