import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/testpage1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커 선언

  static final CameraPosition _startPosition = CameraPosition(
    target: LatLng(37.48744890972421, 126.82055342669355), //유한대학교 임시
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('메인페이지(구글지도)'),
          actions: <Widget>[
            IconButton(
              onPressed: () {}, //검색버튼(임시) 새로고침?
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {}, //설정버튼(임시)
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
                  accountEmail: Text('구글 이메일 구현')),
              //메뉴 리스트
              ListTile(
                leading: Icon(
                  //메뉴1 아이콘
                  Icons.home,
                  color: Colors.grey[850],
                ),
                title: Text('메뉴1'), //메뉴1 텍스트
                onTap: () {
                  //메뉴1 동작
                  Navigator.push(
                      //네비게이터
                      context,
                      MaterialPageRoute(
                          //페이지 이동
                          builder: (context) => testpage1()));
                },
                trailing: Icon(Icons.arrow_forward_ios), //메뉴1 화살표
              ),
              ListTile(
                leading: Icon(
                  //메뉴2 아이콘
                  Icons.account_box,
                  color: Colors.grey[850],
                ),
                title: Text('메뉴2'), //메뉴2 텍스트
                onTap: () {}, //메뉴2 동작
                trailing: Icon(Icons.arrow_forward_ios), //메뉴2 화살표
              ),
            ],
          ),
        ),

        //홈 구글맵 구현
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('좌표(임시)').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();//로딩
            } else {
              print("스트림빌더 작동");
              markers = {};//마커 초기화
              
              snapshot.data!.docs.forEach((change) {//마커 입력
                var markerIdVal = change.id;
                final MarkerId markerId = MarkerId(markerIdVal);
                markers[markerId] = Marker(
                  markerId:  markerId,
                  position: LatLng(
                      change['location'].latitude,
                      change['location'].longitude
                  ),
                  infoWindow: InfoWindow(
                      title: change['name']
                  ),
                );
              });
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _startPosition,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                print("구글맵 로딩");
              },
            );
            }
          }
        ),
    );
  }
}
