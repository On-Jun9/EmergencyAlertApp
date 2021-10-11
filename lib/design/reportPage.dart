import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_team_project/design/ReportGoogleMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

enum emer { u, m, d }

File? _image;
LatLng? tapLatLng;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  emer? _emer = emer.u;
  final _valueList = ['교통사고', '화재', '기타'];
  var _selectedValue = '교통사고';
  String _comment = '';

  var location = new Location();
  GeoPoint currentGeo = GeoPoint(0, 0);
  LatLng currentPosition = LatLng(0, 0);
  String _choise = '';
  String userUid = '';

  @override
  void initState() {
    super.initState();
    _image = null;
    currentLocation();
    FirebaseAuth.instance.currentUser == null
        ? userUid = ''
        : userUid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('제보하기')),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: Text('긴급도', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('상'),
            leading: Radio(
              value: emer.u,
              groupValue: _emer,
              onChanged: (emer? value) {
                setState(() {
                  _emer = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('중'),
            leading: Radio<emer>(
              value: emer.m,
              groupValue: _emer,
              onChanged: (emer? value) {
                setState(() {
                  _emer = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('하'),
            leading: Radio<emer>(
              value: emer.d,
              groupValue: _emer,
              onChanged: (emer? value) {
                setState(() {
                  _emer = value;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text('유형', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(20,8,8,8),
              child: DropdownButton(
                value: _selectedValue,
                items: _valueList.map(
                      (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value.toString();
                  });
                },
              )),
          Container(
            margin: EdgeInsets.all(8),
            child: Text('설명', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20,8,8,8),
            child: TextFormField(
              autofocus: false,
              maxLength: 20,
              onChanged: (text) {
                _comment = text;
              },
              decoration: InputDecoration(
                helperText: '상황 설명',
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text('사진첨부', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            child: SizedBox(
              height: 100,
              width: 100,
              child: _image == null
                  ? Center(child: Text('사진없음'))
                  : Image.file(_image!),
            ),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _takePhoto(ImageSource.gallery);
                });
              },
              child: Text('갤러리')),
          Container(
            margin: EdgeInsets.all(8),
            child: Text('위치', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.all(18),
            child: Text(_choise),
          ),
          TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  //네비게이터
                    context,
                    MaterialPageRoute(
                      //페이지 이동
                        builder: (context) => ReportGoogleMap()));
                print(result);
                setState(() {
                  result == null
                      ? print(result)
                      : _choise = result.latitude.toString() +
                      ' , ' +
                      result.longitude.toString();
                  result == null
                      ? print(result)
                      : currentGeo = GeoPoint(result.latitude!.toDouble(),
                      result.longitude!.toDouble());
                });
              },
              child: Text('위치 변경')),
          ElevatedButton(
            child: Text('제보하기'),
            onPressed: () {
              addFirestore();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future _takePhoto(ImageSource imageSource) async {//사진 가져오기
    var image = await ImagePicker()
        .pickImage(source: imageSource, maxHeight: 300, maxWidth: 300);
    setState(() {
      image == null ? _image = null : _image = File(image.path);
    });
  }

  Future<void> currentLocation() async {//위치 불러오기
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      currentPosition = LatLng(_locationData.latitude!.toDouble(),
          _locationData.longitude!.toDouble());
      _choise =
          '${currentPosition.latitude.toString()} , ${currentPosition.longitude.toString()}(현재위치)';
      currentGeo =
          GeoPoint(currentPosition.latitude, currentPosition.longitude);
    });
  }

  Future<void> addFirestore() async {
    //데이터 삽입
    try{
      FirebaseFirestore.instance.collection('제보').add({
        'uid': userUid,
        '긴급도': _emer.toString(),
        '설명': _comment,
        '유형': _selectedValue,
        '좌표': currentGeo,
        '제보시간': FieldValue.serverTimestamp()
      }).then((value) => {
        if (_image == null)
          {print('no Image')}
        else
          {
            FirebaseStorage.instance
                .ref()
                .child('images/${value.id}')
                .putFile(_image!),
          }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('제보 성공!')));
    }catch(error){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('제보 실패')));
    }

  }

}
