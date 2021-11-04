// import 'package:emergency_post/board.dart';
// import 'package:emergency_post/modify_form.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(BoardContent());
//
// class ReplyData {
//   int replySortingNum;
//
//   int replyNum; // 댓글에 번호를 부여하기 위한 변수
//   String writer;
//   String reply;
//   DateTime replyDatetime; // 댓글 삽입 시간
//
//
//   ReplyData(this.replySortingNum, this.replyNum, this.writer, this.reply, this.replyDatetime);
// }
//
// class BoardContent extends StatefulWidget {
//
//
//   final BoardData selected_item;
//   bool isNoModify;
//
//
//
//   BoardContent({Key? key, @required this.selected_item, @required this.isNoModify}) : super(key: key);
//
//
//
//   @override
//   _BoardContentState createState() => _BoardContentState();
// }
//
// enum Settings { modify, delete }
// class _BoardContentState extends State<BoardContent> {
//
//   int i_replySorting = -1;
//   int i_reply = 1;
//
//   String date_updating;
//   String insert_date;
//
//
//   final _replyItems = <ReplyData>[];
//   double list_size = 0.0;
//   static const int MODIFY_DATA = 1;
//   static const int DELETE_DATA = 2;
//
//   DateTime now = DateTime.now();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // print(widget.selected_item.listNum.toString()+' 번째 게시글 위젯 생성 (initState)');
//   }
//
//
//   var _replyController = TextEditingController();
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _replyController.dispose();
//     super.dispose();
//     // print(widget.selected_item.listNum.toString()+' 번째 게시글 위젯 종료 (dispose)');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // print(widget.selected_item.listNum.toString()+' 번째 게시글 실행 (build)');
//     // print('넘어온 뒤 수정한 이력체크');
//     // print(widget.isNoModify);
//     _DatePrint();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: Text(
//           '응급의료 게시판',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: <Widget>[
//           Container(
//             color: Colors.blueGrey[50],
//             child: Padding(
//               padding: const EdgeInsets.only(left: 25, top: 7, right: 25, bottom: 7),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       '작성자'+'\n'+widget.selected_item.writer,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontSize: 17, color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       date_updating,
//                       textAlign: TextAlign.end,
//                       style: TextStyle(
//                         fontSize: 12, color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//                 left: 25, top: 15, right: 25, bottom: 15),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   flex: 7,
//                   child: Text(
//                     widget.selected_item.title,
//                     style: TextStyle(
//                       fontSize: 23,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//
//                   child: PopupMenuButton<Settings>(
//                     onSelected: (Settings result) {
//                       print(result);
//                       switch(result) {
//                         case Settings.modify:
//                         // 게시글 수정 네비게이터
//                           _navigateAndModifyData(context);
//                           break;
//                         case Settings.delete:
//                         // 게시글 삭제 네비게이터
//                           _MakeSureWhetherDeleteThisItem(context);
//                           break;
//                       }
//                     },
//                     itemBuilder: (BuildContext context) =>
//                     <PopupMenuEntry<Settings>>[
//                       const PopupMenuItem<Settings>(
//                         value: Settings.modify,
//                         child: Text('게시글 수정'),
//                       ),
//                       const PopupMenuItem<Settings>(
//                         value: Settings.delete,
//                         child: Text('게시글 삭제'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Center(
//             child: Container(
//               color: Colors.black12,
//               width: 350,
//               height: 1,
//             ),
//           ),
//           Container(
//             height: 300,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 25, top: 15, right: 25, bottom: 15),
//               child: ListView(
//                 children: <Widget>[
//                   Text(
//                     widget.selected_item.description,
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           Container(
//             color: Colors.black12,
//             width: 350,
//             height: 1,
//           ),
//
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 25, top: 15, right: 25, bottom: 15),
//               child: Text(
//                 '댓글',
//                 style: TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//
//           Container(
//
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 15),
//               child: Row(
//                 children: <Widget>[
//
//                   Expanded(
//
//
//                     flex: 3,
//
//
//
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 27, right: 15),
//                       child: TextField(
//                         controller: _replyController,
//                         decoration: InputDecoration(
//
//                           border: OutlineInputBorder(),
//                           hintText: '댓글쓰기',
//                           hintStyle: TextStyle(
//                             color: Colors.black26,
//                           ),
//
//                         ),
//                         style: TextStyle(
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 25),
//                       child: ElevatedButton(
//                         child: Text('등록', style: TextStyle(color: Colors.white, fontSize: 18,), ),
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.blueAccent,
//                           minimumSize: Size(30, 60),
//                           shadowColor: ThemeData(shadowColor: Colors.white,).shadowColor,
//                         ),
//                         onPressed: () {
//                           // text가 listtile로 출력됨. - listtile 내에서 삭제기능만 넣을 예정.
//                           print('댓글 정렬 값 : '+i_replySorting.toString());
//                           print('댓글 순번 : '+i_reply.toString());
//                           _addReplyData(ReplyData(i_replySorting, i_reply, widget.selected_item.writer, _replyController.text, now));
//
//                           // pop 이 되어서 DB가 있다고 해도 변수 값이 리셋됨.
//                           i_replySorting--;
//                           i_reply++;
//
//                           list_size += 140;
//                         },
//                       ),
//
//
//                     ),
//                   ),
//
//
//
//
//
//
//
//                 ],
//               ),
//             ),
//           ),
//
//
//           Container(
//             color: Colors.black12,
//             width: 350,
//             height: 1,
//           ),
//
//
//           Container(
//             height: list_size,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 25, top: 15, right: 25, bottom: 15),
//               child: ListView(
//                 children: _replyItems.map((data) => _buildReplyWidget(data)).toList(),
//               ),
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//
//   // 날짜 출력 방식 전환
//   void _DatePrint() {
//
//     if(widget.isNoModify=true) {
//       insert_date = widget.selected_item.datetime;
//       setState(() {
//         date_updating = '작성 날짜'+'\n'+widget.selected_item.datetime;
//       });
//
//     }
//     else if(widget.isNoModify=false) {
//       setState(() {
//         date_updating = '마지막으로 수정된 날짜'+'\n'+widget.selected_item.datetime;
//       });
//
//     }
//   }
//   //
//   // // 게시글 수정 네비게이터
//   // _navigateAndModifyData(BuildContext context) async {
//   //
//   //   BoardData set_data = new BoardData(
//   //       widget.selected_item.listSortingNum,
//   //       widget.selected_item.listNum,
//   //       widget.selected_item.writer,
//   //       widget.selected_item.title,
//   //       widget.selected_item.description,
//   //       widget.selected_item.datetime,
//   //       widget.selected_item.isNoModify);
//   //
//   //   BoardData get_data = new BoardData(
//   //       widget.selected_item.listSortingNum,
//   //       widget.selected_item.listNum,
//   //       widget.selected_item.writer,
//   //       null,
//   //       null,
//   //       null,
//   //       widget.selected_item.isNoModify);
//   //
//   //   get_data = await Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) =>
//   //           ModifyForm(get_data_for_modifying: set_data),
//   //     ),
//   // //   );
//   //
//   //
//   //
//   //
//   //   if(get_data==null) {
//   //     return;
//   //   }
//   //
//   //   else {
//   //     try {
//   //       print('게시글 수정 작업 로직으로 넘어옴');
//   //
//   //       print('게시글 정렬 값 : '+widget.selected_item.listSortingNum.toString());
//   //       print('');
//   //       print('게시글 번호 : '+widget.selected_item.listNum.toString());
//   //       print('');
//   //       print('수정하기 전 제목 : '+widget.selected_item.title.toString());
//   //       print('수정하기 전 내용 : '+widget.selected_item.description.toString());
//   //       print('');
//   //       print('수정할 제목 : '+get_data.title.toString());
//   //       print('수정할 내용 : '+get_data.description.toString());
//   //       print('게시글이 마지막으로 수정된 시간 : '+get_data.datetime.toString());
//   //       print('');
//   //       print('이후, 수정처리됨');
//   //     }
//   //     catch(on, StackTrace) {
//   //       StackFrame.asynchronousSuspension;
//   //     }
//   //
//   //
//   //
//   //     // 수정 처리
//   //     final return_item = new ManipulateData(get_data.listNum, get_data.title, get_data.description, MODIFY_DATA);
//   //     Navigator.pop(context, return_item);
//   //
//   //   }
//   //
//   // } // 게시글 수정 네비게이터 부분 끝.
//
//   // 게시글 삭제 네비게이터
//   _MakeSureWhetherDeleteThisItem(BuildContext context) async {
//     var delete_flag = false; // (bool) : 삭제할 것인지 신호를 받는 역할
//
//     // 필요성
//     int item_listSortingNo = widget.selected_item.listSortingNum;
//     int item_listNo = widget.selected_item.listNum;
//     String item_title = widget.selected_item.title;
//     String item_description = widget.selected_item.description;
//     String item_datetime = widget.selected_item.datetime;
//
//     delete_flag = await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('이 게시글을 삭제하시겠습니까?'),
//               ],
//             ),
//           ),
//           contentPadding:
//           EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//
//                 // stack에서 alert 창 pop
//                 Navigator.pop(context, true);
//
//               },
//               child: Text('확인'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('취소'),
//             ),
//           ],
//         );
//       },
//     );
//
//
//     if(delete_flag==true) {
//
//       print('게시글 삭제 작업 로직으로 넘어옴');
//
//       print('게시글 정렬 값 : '+item_listSortingNo.toString());
//       print('');
//       print('게시글 번호 : '+item_listNo.toString());
//       print('');
//       print('삭제될 게시글의 제목 : '+item_title.toString());
//       print('삭제될 게시글의 내용 : '+item_description.toString());
//       print('');
//       print('게시글이 마지막으로 수정된 시각 : '+item_datetime.toString());
//       print('');
//       print('이후, 삭제처리됨');
//
//       // final return_item = new ManipulateData(item_listNo, item_title, item_description, DELETE_DATA);
//       // Navigator.pop(context, return_item);
//       Navigator.pop(context);
//
//     }
//
//
//   }
//
//
//   // 댓글 삭제 여부 묻기
//   _MakeSureWhetherDeleteThisReply(ReplyData data) async {
//     var delete_flag = false; // 삭제할 것인지 신호를 받음
//
//
//     // this.listSortingNum, this.id, this.reply
//
//
//     delete_flag = await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('이 댓글을 삭제하시겠습니까?'),
//               ],
//             ),
//           ),
//           contentPadding:
//           EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//
//                 // stack에서 alert 창 pop
//                 Navigator.pop(context, true);
//
//               },
//               child: Text('확인'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('취소'),
//             ),
//           ],
//         );
//       },
//     );
//
//
//     if(delete_flag==true) {
//
//       print('댓글 삭제 작업 로직으로 넘어옴');
//
//
//       print('삭제될 댓글 정렬 값 : '+data.replySortingNum.toString());
//       print('삭제될 댓글 순번 : '+data.replyNum.toString());
//       print('');
//       print('댓글이 등록된 시간 : '+data.replyDatetime.toString());
//       print('');
//       print('이후, 삭제처리됨');
//
//       _deleteReplyData(data);
//
//       print('댓글 삭제 완료');
//
//     }
//
//
//   }
//
//   // 댓글 목록 출력 부분
//
//   Widget _buildReplyWidget(ReplyData data) {
//
//     // data.writer = selected_item.writer;
//
//     return Column(
//       children: <Widget>[
//         ListTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   data.writer,
//                   style: TextStyle(color: Colors.black45),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   data.reply,
//                 ),
//               ),
//             ],
//           ),
//           trailing: IconButton(
//               icon: Icon(Icons.remove),
//               onPressed: () {
//
//                 // 댓글 삭제 여부 묻기.
//                 _MakeSureWhetherDeleteThisReply(data);
//
//               }
//           ),
//         ),
//         Container(
//           color: Colors.black12,
//           height: 1,
//         ),
//       ],
//     );
//   }
//   //
//   // // 댓글 목록에 댓글이 추가 됨
//   //
//   // Widget _addReplyData(ReplyData data) {
//   //   setState(() {
//   //     _replyItems.add(data);
//   //     _replyItems.sort((a,b) => a.replySortingNum.compareTo(b.replySortingNum));
//   //     _replyController.text='';
//   //   });
//   // }
//   //
//   // // 댓글 목록에서 댓글이 삭제 됨
//   //
//   // Widget _deleteReplyData(ReplyData data) {
//   //   setState(() {
//   //     _replyItems.remove(data);
//   //     _replyItems.sort((a,b) => a.replySortingNum.compareTo(b.replySortingNum));
//   //   });
//   // }
//
// }
