import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/testpage1.dart';

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('메인페이지(구글지도)'),
          actions: <Widget>[
            IconButton(
              onPressed: () {},//검색버튼(임시) 새로고침?
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},//설정버튼(임시)
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),

        //사이드 메뉴 drawer
        drawer: Drawer(
          child: ListView(
            // padding: EdgeInsets.only(right: 10.0),
            children: <Widget>[
              //메뉴 로그인
              UserAccountsDrawerHeader(
                  accountName: Text('구글 이름 구현'),
                  accountEmail: Text('구글 이메일 구현')
              ),
              //메뉴 리스트
              ListTile(
                leading: Icon(//메뉴1 아이콘
                  Icons.home,
                  color: Colors.grey[850],
                ),
                title: Text('메뉴1'),//메뉴1 텍스트
                onTap: (){//메뉴1 동작
                  Navigator.push(//네비게이터
                      context,
                      MaterialPageRoute(//페이지 이동
                          builder: (context)=> testpage1()
                      )
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),//메뉴1 화살표
              ),
              ListTile(
                leading: Icon(//메뉴2 아이콘
                  Icons.account_box,
                  color: Colors.grey[850],
                ),
                title: Text('메뉴2'),//메뉴2 텍스트
                onTap: (){},//메뉴2 동작
                trailing: Icon(Icons.arrow_forward_ios),//메뉴2 화살표
              )
            ],
          ),
        ),

        //홈 구글맵 구현
        body: Text('구글맵 구현'),
      );
  }
}
