import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/boardPage.dart';
import 'package:flutter_team_project/design/firstAidPage.dart';
import 'package:flutter_team_project/design/googleLogin.dart';

class drawerMenu extends StatefulWidget {
  const drawerMenu({Key? key}) : super(key: key);

  @override
  _drawerMenuState createState() => _drawerMenuState();
}

class _drawerMenuState extends State<drawerMenu> {

  Stream? authState;

  var _login = LoginWidget();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authState = FirebaseAuth.instance.authStateChanges();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //로그인중
            return ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL.toString()),
                  accountName: Text(FirebaseAuth
                      .instance.currentUser!.displayName
                      .toString() +
                      ' 으로 로그인중'),
                  accountEmail:
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                ListTile(
                  leading: Icon(
                    //메뉴3 아이콘
                    Icons.account_box,
                    color: Colors.grey[850],
                  ),
                  title: Text('로그아웃'), //메뉴2 텍스트
                  onTap: () {
                    //메뉴2 동작
                    // _login.signInWithGoogle();
                    FirebaseAuth.instance.signOut();
                  },
                  // trailing: Icon(Icons.arrow_forward_ios), //메뉴1 화살표
                ),
                ListTile(
                  leading: Icon(
                    //메뉴3 아이콘
                    Icons.check,
                    color: Colors.grey[850],
                  ),
                  title: Text('응급처치 요령'), //메뉴2 텍스트
                  onTap: () {
                    Navigator.push(
                      //네비게이터
                        context,
                        MaterialPageRoute(
                          //페이지 이동
                            builder: (context) => firstaid()));
                  }, //메뉴2 동작
                  trailing: Icon(Icons.arrow_forward_ios), //메뉴2 화살표
                ),
                ListTile(
                  leading: Icon(
                    //메뉴3 아이콘
                    Icons.insert_comment_outlined,
                    color: Colors.grey[850],
                  ),
                  title: Text('게시판'), //메뉴3 텍스트
                  onTap: () {
                    Navigator.push(
                      //네비게이터
                        context,
                        MaterialPageRoute(
                          //페이지 이동
                            builder: (context) => boardPage()));
                  }, //메뉴2 동작
                  trailing: Icon(Icons.arrow_forward_ios), //메뉴2 화살표
                )
              ],
            );
          } else {
            return ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(''),
                  accountEmail: Text('로그인시 다양한 기능을 사용하실 수 있습니다'),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                ListTile(
                  leading: Icon(
                    //메뉴2 아이콘
                    Icons.account_box,
                    color: Colors.grey[850],
                  ),
                  title: Text('로그인'), //메뉴2 텍스트
                  onTap: () {
                    //메뉴2 동작
                    _login.signInWithGoogle();
                    // FirebaseAuth.instance.signOut();
                  },
                  // trailing: Icon(Icons.arrow_forward_ios), //메뉴1 화살표
                ),
                ListTile(
                  leading: Icon(
                    //메뉴3 아이콘
                    Icons.check,
                    color: Colors.grey[850],
                  ),
                  title: Text('응급처치 요령'), //메뉴2 텍스트
                  onTap: () {
                    Navigator.push(
                      //네비게이터
                        context,
                        MaterialPageRoute(
                          //페이지 이동
                            builder: (context) => firstaid()));
                  }, //메뉴2 동작
                  trailing: Icon(Icons.arrow_forward_ios), //메뉴2 화살표
                ),
                ListTile(
                  leading: Icon(
                    //메뉴3 아이콘
                    Icons.insert_comment_outlined,
                    color: Colors.grey[850],
                  ),
                  title: Text('게시판'), //메뉴3 텍스트
                  onTap: () {
                    Navigator.push(
                      //네비게이터
                        context,
                        MaterialPageRoute(
                          //페이지 이동
                            builder: (context) => boardPage()));
                  }, //메뉴2 동작
                  trailing: Icon(Icons.arrow_forward_ios), //메뉴2 화살표
                )
              ],
            );
          }
        });
  }
}
