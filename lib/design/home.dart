import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/ShowDialog.dart';
import 'package:flutter_team_project/design/drawer.dart';
import 'package:flutter_team_project/design/reportPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커 선언
  String locaname = '';
  LatLng currentPosition = LatLng(0, 0);
  var location = new Location();
  String imageUrl = '';
  String markerIdVal = '';
  int sliderVal = 10;
  int _markerTime = 10;

  @override
  void initState() {
    super.initState();
    currentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주변 응급 상황'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              sliderVal = _markerTime;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return SimpleDialog(
                      title: Text('제보 설정'),
                      children: [
                        Center(
                            child:
                                Text('현재 설정값 : 최근 ${_markerTime.toString()} 분')),
                        Slider(
                            value: sliderVal.toDouble(),
                            min: 0,
                            max: 60,
                            divisions: 12,
                            label: sliderVal.toString() + ' 분',
                            onChanged: (double value) {
                              setState(() {
                                sliderVal = value.round();
                              });
                            }),
                        Center(
                          child: Text('0 으로 설정시 모든 제보를 보여줍니다'),
                        ),
                        TextButton(
                          child: new Text('설정'),
                          onPressed: () {
                            _markerTime = sliderVal;
                            currentLocation();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
                },
              );
            }, //설정버튼
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      //사이드 메뉴 drawer
      drawer: Drawer(child: drawerMenu()),

      //홈 구글맵 구현
      body: currentPosition == LatLng(0, 0)
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('제보').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator()); //로딩
                } else {
                  print("스트림빌더 작동");
                  markers = {}; //마커 초기화
                  snapshot.data!.docs.forEach((change) {
                    Timestamp? time = change['제보시간'];
                    if(time == null){
                      time = Timestamp(1633964070, 0);
                    }
                    if (_markerTime != 0 ? _markerTime > DateTime.now().difference(time.toDate()).inMinutes : true) {
                      //10분 체크
                      var markerIdVal = change.id;
                      final MarkerId markerId = MarkerId(markerIdVal);
                      markers[markerId] = Marker(
                        markerId: markerId,
                        onTap: () {},
                        position: LatLng(
                            change['좌표'].latitude, change['좌표'].longitude),
                        infoWindow: InfoWindow(
                          title: change['유형'] == '' ? '설명없음' : change['유형'],
                          snippet: change['설명'].trim() == '' ? '설명없음' : change['설명'],
                          onTap: () {
                            setState(() {
                              // markerIdVal = markerIdVal;
                              print(markerIdVal);
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ShowDialog(
                                  markerIdVal: markerIdVal,
                                );
                              },
                            );
                          },
                        ),
                      );
                    } //10체크 if
                  });
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: currentPosition,
                      zoom: 14.4746,
                    ),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,

                    markers: Set<Marker>.of(markers.values),
                    // onTap: (LatLng latlng) {
                    //   print(latlng);
                    //   tapMap = latlng;
                    // },
                    onMapCreated: (GoogleMapController controller) {
                      if(!_controller.isCompleted){
                        _controller.complete(controller);
                      }else{
                      }
                      print("구글맵 로딩");
                    },
                  );
                }
              }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('로그인이 필요합니다.')));
            } else {
              Navigator.push(
                  //네비게이터
                  context,
                  MaterialPageRoute(
                    //페이지 이동
                    builder: (context) => ReportPage(),
                  ));
            }
          }, //변경
          label: Text('제보')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> currentLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      currentPosition = LatLng(_locationData.latitude!.toDouble(),
          _locationData.longitude!.toDouble());
      print(currentPosition.toString());
    });
  }
}
