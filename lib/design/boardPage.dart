import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/insertForm.dart';

class boardPage extends StatefulWidget {
  const boardPage({Key? key}) : super(key: key);

  @override
  _boardPageState createState() => _boardPageState();
}

class _boardPageState extends State<boardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시판"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              //todo 네이게이터
              Navigator.push(
                //네비게이터
                  context,
                  MaterialPageRoute(
                    //페이지 이동
                    builder: (context) => InsertForm(),
                  ));
            },
          ),
        ],
      ),
      body: ListView(
        children: [

        ],

      ),
    );
  }
}
