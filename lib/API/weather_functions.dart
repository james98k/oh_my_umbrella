/*
 * Copyright Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:oh_my_umbrella/API/geoLocation.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

import 'package:geolocator/geolocator.dart';

import './Firebase.dart';

enum WeatherState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

FirebaseFirestore db = FirebaseFirestore.instance;

class OMUProvider with ChangeNotifier {
  Future<Weather?> _callWeather() async {
    return Future.delayed(Duration(seconds: 2), () => fetchData());

    return _data;
  }

  OMUProvider() {
    queryForecast();
    queryWeather();
    getSnapshotFromDb();
  }

  String key = '856822fd8e22db5e1ba48c0e7d69844a';

  double locationLat = 0.0;
  double locationLong = 0.0;

  bool _isRaining = false;

  StreamSubscription<QuerySnapshot> ? _locationSubscription;

  List<LocationInfo> _locationInfoList = [];
  List<LocationInfo> get getLocationInfoList => _locationInfoList;


  WeatherFactory ws = WeatherFactory('856822fd8e22db5e1ba48c0e7d69844a');

  Weather? _data;

  get wData => _data;
  List<Weather> _forecast = [];

  Weather? get getWeatherData => _data;
  List<Weather> get getForecastList => _forecast;

  String _weatherCode = "0";
  String get getWeatherCode => _weatherCode;

  String _positionName = "";

  String get getPositionName => _positionName;
  WeatherState _wState = WeatherState.NOT_DOWNLOADED;
  late Timer _timer;

  // =====================Weather

  Future<Weather?> setWeatherFactory() async {
    ws = WeatherFactory(key);
    notifyListeners();
    return null;
  }

  Future<Weather?> fetchData() async {
    await setWeatherFactory();
    await queryWeather();
    await queryForecast();
    return null;
  }

  Future<List<Weather>> queryForecast() async {
    /// Removes keyboard

    // FocusScope.of(context).requestFocus(FocusNode());
    _wState = WeatherState.DOWNLOADING;
    _forecast = (await ws.fiveDayForecastByLocation(locationLat, locationLong));


    _wState = WeatherState.FINISHED_DOWNLOADING;

    print("==============fetch forecast");
    print(_forecast.length);

    notifyListeners();
    return _forecast;
  }

  Future<Weather?> queryWeather() async {
    /// Removes keyboard

    // FocusScope.of(context).requestFocus(FocusNode());
    await getPosition();
    _wState = WeatherState.DOWNLOADING;

    print("${locationLat} AND  ${locationLong}");

    Weather forecasts =
    (await ws.currentWeatherByLocation(locationLat, locationLong));

    _data = forecasts;
    _wState = WeatherState.FINISHED_DOWNLOADING;

    print("==============fetch weather");
    print(_data?.weatherConditionCode);
    String? weatherCode = _data?.weatherConditionCode.toString();
    weatherCode = weatherCode![0];
    _weatherCode = weatherCode;
    print("=================weather code : $weatherCode");
    print("=================weather area name : ${_data?.country}");
    print(_data);


    _positionName =
    await getAddressFromLatLong(locationLat, locationLong) as String;

    if (weatherCode == "2" || weatherCode == "3" || weatherCode == "5" ||
        weatherCode == "6" || weatherCode == "8") {
      _isRaining = true;
      print("_israining = true");
      handleLocationCollecting();
    }
    else {
      _isRaining = false;
    }

    // notifyListeners();
    return _data;
  }

  //==================location

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low).catchError((e) {
      print(e);
    });


    print("${position.latitude} and ${position.longitude}");
    locationLat = position.latitude;
    locationLong = position.longitude;
    // GetAddressFromLatLong(locationLat, locationLong);

    // _positionName = GetAddressFromLatLong(position) as String;
    notifyListeners();
    return position;
  }

  Future<String?> getAddressFromLatLong(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    // print(placemarks);
    Placemark place = placemarks[0];
    var Address = '${place.street}, ${place.subLocality}, ${place
        .locality}, ${place.postalCode}, ${place.country}';
    // print("place name ===============${place.name}");
    // print(placemarks[0].street);
    _positionName = place.street!;
    notifyListeners();
    String? placeName = place.name;
    return placeName;
  }


  bool handleLocationCollecting() {
    if (_isRaining == true) {
      _timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
        double pastLocationLat = locationLat;
        double pastLocationLong = locationLong;

        Position? newPosition = await getPosition();
        print("=============================position ? $newPosition");
        print("position get activated");
        if (pastLocationLat == newPosition.latitude &&
            pastLocationLong == newPosition.longitude) {
          print("position is same");
          print(
              "past lat : $pastLocationLat past long : $pastLocationLong current lat : ${newPosition
                  .latitude} current long : ${newPosition.longitude}");
        }
        else {
          print("position is uploaded to db");
          getAddressFromLatLong(newPosition.latitude, newPosition.longitude);
          addPinInfoToDb();
        }
        notifyListeners();
      });
    }
    else {
      print("not raining");
    }
    return _isRaining;
  }


  void addPinInfoToDb() async {
    String? uid = ApplicationState().user?.uid;
    if (uid == null) {
      print("user id = null");
    }
    else {
      print("user id = $uid");

      db.collection("location").doc().set(<String, dynamic>{
        'userId': uid,
        'lat': locationLat,
        'long': locationLong,
        'serverTimeStamp': DateTime
            .now()
            .millisecondsSinceEpoch,
        'locationName' : _positionName,
      }).whenComplete(() => print("pin added to DB"));
    }
  }

  Future getSnapshotFromDb() async {
    print("===============================get snapshot");
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _locationSubscription = FirebaseFirestore.instance
            .collection('location')
            .orderBy('serverTimeStamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _locationInfoList = [];

          for (final document in snapshot.docs) {
            print("wwwwwwwwwwwwwwwwwwwwwwwwww : " + document.id);
            _locationInfoList.add(
              LocationInfo(
                uid: document.data()['userId'] as String,
                latitude: document.data()['lat'] as double,
                longitude: document.data()['long'] as double,
                timestamp: document.data()['serverTimeStamp'] as int,
                locationName : document.data()['locationName'] as String,

              ),
            );
          }
        });
      }
    notifyListeners();
    });


  return _locationInfoList;
  }

}

class LocationInfo{
  LocationInfo({required this.uid, required this.latitude, required this.longitude, required this.timestamp, required this.locationName});

  final String? uid;
  final double latitude;
  final double longitude;
  final int timestamp;
  final String locationName;


}