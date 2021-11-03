import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

      ),
    );
  }
}
