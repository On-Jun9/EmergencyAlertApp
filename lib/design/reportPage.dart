import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key, this.tapLatLng}) : super(key: key);

  final tapLatLng;

  // ReportPage(LatLng latLng){
  //   this.tapLatLng = latLng;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제보 페이지'),
      ),
      body: Text(tapLatLng.toString()),
    );
  }
}
