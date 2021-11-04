import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/boardPage.dart';
import 'package:flutter_team_project/design/modifyForm.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class BoardContent extends StatefulWidget {
  const BoardContent({Key? key, required this.selected_item}) : super(key: key);
  final BoardData selected_item;

  @override
  _BoardContentState createState() => _BoardContentState();
}

enum Settings { modify, delete }

class _BoardContentState extends State<BoardContent> {
  double list_size = 0.0;
  String sWriter = '';
  String sTitle = '';
  Timestamp sTime = Timestamp(0, 0);
  String sContent = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('게시판')
            .doc(widget.selected_item.docName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            sWriter = snapshot.data!['writer'];
            sTime = snapshot.data!['time'];
            sTitle = snapshot.data!['title'];
            sContent = snapshot.data!['content'];
            BoardData selectedData = BoardData(widget.selected_item.docName);
            return Scaffold(
                appBar: AppBar(
                  title: Text('게시판'),
                ),
                body: ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.blueGrey[50],
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 7, right: 25, bottom: 7),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                '작성자' + '\n' + sWriter,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                DateFormat.yMd('ko_KR')
                                    .add_jms()
                                    .format(sTime.toDate())
                                    .toString(),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black26,
                      width: 350,
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, top: 15, right: 25, bottom: 15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: Text(
                              sTitle,
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: PopupMenuButton<Settings>(
                              onSelected: (Settings result) {
                                print(result);
                                switch (result) {
                                  case Settings.modify:
                                    // 게시글 수정 네비게이터
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          //페이지 이동
                                          builder: (context) =>
                                              ModifyForm(sDocId: selectedData),
                                        )).then((value) => setState(() {}));
                                    break;
                                  case Settings.delete:
                                    // 게시글 삭제 네비게이터
                                    _MakeSureWhetherDeleteThisItem(context);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<Settings>>[
                                const PopupMenuItem<Settings>(
                                  value: Settings.modify,
                                  child: Text('게시글 수정'),
                                ),
                                const PopupMenuItem<Settings>(
                                  value: Settings.delete,
                                  child: Text('게시글 삭제'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        color: Colors.black12,
                        width: 350,
                        height: 1,
                      ),
                    ),
                    Container(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 15, right: 25, bottom: 15),
                        child: ListView(
                          children: <Widget>[
                            Text(
                              sContent,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      width: 350,
                      height: 1,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 15, right: 25, bottom: 15),
                        child: Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 27, right: 15),
                                child: TextField(
                                  // controller: _replyController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '댓글쓰기',
                                    hintStyle: TextStyle(
                                      color: Colors.black26,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: ElevatedButton(
                                  child: Text(
                                    '등록',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                    minimumSize: Size(30, 60),
                                    shadowColor: ThemeData(
                                      shadowColor: Colors.white,
                                    ).shadowColor,
                                  ),
                                  onPressed: () {
                                    // text가 listtile로 출력됨. - listtile 내에서 삭제기능만 넣을 예정.
                                    // print('댓글 정렬 값 : '+i_replySorting.toString());
                                    // print('댓글 순번 : '+i_reply.toString());
                                    // _addReplyData(ReplyData(i_replySorting, i_reply, widget.selected_item.writer, _replyController.text, now));
                                    //
                                    // // pop 이 되어서 DB가 있다고 해도 변수 값이 리셋됨.
                                    // i_replySorting--;
                                    // i_reply++;
                                    //
                                    list_size += 140;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      width: 350,
                      height: 1,
                    ),
                    Container(
                      height: list_size,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 15, right: 25, bottom: 15),
                        child: ListView(
                            // children: _replyItems.map((data) => _buildReplyWidget(data)).toList(),
                            ),
                      ),
                    ),
                  ],
                )
                // Text(DateFormat.yMd('ko_KR')
                //     .add_jms()
                //     .format(widget.selected_item.time.toDate()).toString() +'\n'+
                //     widget.selected_item.title +'\n'+ widget.selected_item.writer),
                );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('게시판'),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
  _MakeSureWhetherDeleteThisItem(BuildContext context) async {
    var delete_flag = false; // (bool) : 삭제할 것인지 신호를 받는 역할

    delete_flag = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('이 게시글을 삭제하시겠습니까?'),
              ],
            ),
          ),
          contentPadding:
          EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // stack에서 alert 창 pop
                Navigator.pop(context, true);
                FirebaseFirestore.instance.collection('게시판').doc(widget.selected_item.docName).delete().then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제되었습니다.')))
                );
              },
              child: Text('확인'),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pop(context,false);
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );

    if(delete_flag==true) {

     Navigator.pop(context);

    }

  }

}
