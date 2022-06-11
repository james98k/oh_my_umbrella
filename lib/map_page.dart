import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oh_my_umbrella/API/weather_functions.dart';
import 'package:provider/provider.dart';


class MapPage extends StatefulWidget{

  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPage createState() => _MapPage();

}

class _MapPage extends State<MapPage>{


// 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(OMUProvider().locationLat , OMUProvider().locationLong));

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : ChangeNotifierProvider<OMUProvider>(
        create: (ctx) => OMUProvider(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text("omu"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: ()=>{
                  Navigator.pop(context)
                },
              ),
            ),

            body : MapSample(),

        ),
      )
    );
  }
  
}


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> _markers = [];

  List<Marker> addMarker(){

    var document = context.read<OMUProvider>().getLocationInfoList;
    document = document.sublist(1, 10);
    for(var i in document){
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(i.longitude, i.longitude),
      ));
    }

    return _markers;
  }

  @override
  void initState() {
    super.initState();
    // addMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.terrain,
        markers: Set.from(_markers),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),

    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}