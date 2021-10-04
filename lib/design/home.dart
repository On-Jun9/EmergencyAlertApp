import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/drawer.dart';
import 'package:flutter_team_project/design/reportPage.dart';
import 'package:flutter_team_project/design/testpage1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커 선언

  LatLng tapMap = LatLng(37.48744890972421, 126.82055342669355);

  String locaname = '';
  String locaLat1 = '';
  String locaLat2 = '';

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
      drawer: Drawer(child: drawerMenu()),

      //홈 구글맵 구현
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('좌표(임시)').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator()); //로딩
            } else {
              print("스트림빌더 작동");
              markers = {}; //마커 초기화
              snapshot.data!.docs.forEach((change) {
                //마커 입력
                var markerIdVal = change.id;
                final MarkerId markerId = MarkerId(markerIdVal);
                markers[markerId] = Marker(
                  markerId: markerId,
                  onTap: () {
                    getlocainfo(markerIdVal);
                    print(markerIdVal);
                  },
                  position: LatLng(change['location'].latitude,
                      change['location'].longitude),
                  infoWindow: InfoWindow(
                    title: change['name'],
                    snippet: '정보 추가',
                    onTap: () {
                      _showDialog();
                    },
                  ),
                );
              });
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _startPosition,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(markers.values),
                onTap: (LatLng latlng) {
                  print(latlng);
                  tapMap = latlng;
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  print("구글맵 로딩");
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                //네비게이터
                context,
                MaterialPageRoute(
                  //페이지 이동
                  builder: (context) => ReportPage(tapLatLng: tapMap),
                ));
          }, //변경
          label: Text('제보')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void getlocainfo(String markerId) {
    FirebaseFirestore.instance.collection('좌표(임시)').doc(markerId).get().then((ds) {
      locaname = ds.get('name').toString();
      locaLat1 = ds.get('location').latitude.toString();
      locaLat2 = ds.get('location').longitude.toString();
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print('dialog : ' + locaname);
        return AlertDialog(
          title: new Text("제보 화면 보기"),
          content: Container(
            // color: Colors.blue,
              child: Column(
                children: [
                  new Text(locaname),
                  new Text(locaLat1),
                  new Text(locaLat2),
                ],
              )),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}
