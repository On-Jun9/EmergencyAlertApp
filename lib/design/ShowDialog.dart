import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ShowDialog extends StatefulWidget {
  const ShowDialog({Key? key, required this.markerIdVal}) : super(key: key);

  final String markerIdVal;//마커 ID, 이미지 이름

  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    printUrl();
  }
  @override
  Widget build(BuildContext context) {
    var getData = FirebaseFirestore.instance.collection('제보').doc(widget.markerIdVal).get();
    return FutureBuilder<DocumentSnapshot>(
      future: getData,
      builder: (context, snapshot){
        var _emer = '';
        if(snapshot.hasData){
          switch(snapshot.data!['긴급도']){
            case 'emer.u':
              _emer = '상';
              break;
            case 'emer.m':
              _emer = '중';
              break;
            case 'emer.d':
              _emer = '하';
              break;
          }
          //한국시간 변경
          var _time = snapshot.data!['제보시간'].toDate();//.add(Duration(hours: 9))
          return AlertDialog(
            title: Text('상황 정보',style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('제보시간', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(DateFormat.yMd('ko_KR')
                      .add_jms()
                      .format(_time)
                      .toString()),
                  Text('긴급도', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_emer),
                  Text('유형', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(snapshot.data!['유형']),
                  Text('설명', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(snapshot.data!['설명']),
                  ListTile(
                    title: imageUrl == ''
                        ? CircularProgressIndicator()
                        : Image.network(imageUrl),//사진 로딩
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            content: imageUrl == ''
                                ? CircularProgressIndicator()
                                : Image.network(imageUrl,width: 300,height: 300),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }else{
          return AlertDialog(
            title: Text('상황 정보',style: TextStyle(fontWeight: FontWeight.bold)),
            content: Container(child: CircularProgressIndicator()),
          );
        }
      }
    );
  }

  printUrl() async {
    //사진 이름으로 URL 가져오기
    try{
      String url = (await FirebaseStorage.instance
          .ref()
          .child('images/${widget.markerIdVal}')
          .getDownloadURL())
          .toString();
      setState(() {
        imageUrl = url;
      });
    }catch(error){
      String url = (await FirebaseStorage.instance
          .ref()
          .child('images/123.PNG')//사진 없을때
          .getDownloadURL())
          .toString();
      setState(() {
        imageUrl = url;
      });
    }
  }
}
