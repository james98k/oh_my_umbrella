import 'dart:async';
// import 'dart:convert/convert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oh_my_umbrella/API/Firebase.dart';
import 'package:oh_my_umbrella/location_page.dart';
import 'package:oh_my_umbrella/map_page.dart';
import 'package:oh_my_umbrella/webviewPage.dart';
import 'package:provider/provider.dart'; // new
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

import 'API/geoLocation.dart';
import 'API/weatherApi.dart';
import 'API/weather_functions.dart';

import 'login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var weather;

  var color = 0xffC9F2BF;
  var imageUrl = 'assets/images/sunny_black.png';

  String handleWeatherImage() {
    // Image.asset('assets/images/snowy_black.png',
    switch (context.read<OMUProvider>().getWeatherCode) {
      case "0":
        this.color = 0xffABD3A0;

        this.imageUrl = 'assets/images/sunny_black.png';
        break;
      case "2":
        this.color = 0xff9CB5C9;
        this.imageUrl = 'assets/images/umbrella_black';
        break;
      case "3":
        this.color = 0xff9CB5C9;
        this.imageUrl = 'assets/images/umbrella_black';
        break;
      case "5":
        this.color = 0xff9CB5C9;
        this.imageUrl = 'assets/images/umbrella_black';
        break;
      case "6":
        this.color = 0xff9CB5C9;
        this.imageUrl = "assets/images/snowy_black.png";
        break;
      case "7":
        this.color = 0xffABD3A0;
        this.imageUrl = "assets/images/sunny_black.png";
        break;
      case "8":
        this.color = 0xffABD3A0;
        this.imageUrl = "assets/images/sunny_black.png";
        break;
    }
    return "";
  }

  String formatTemperature(Temperature? t) {
    String rawFormat = t.toString();
    String newFormat = rawFormat.substring(0, 4);
    newFormat += "℃";
    return newFormat;
  }

  @override
  Widget build(BuildContext context) {
    weather = context.watch<OMUProvider>().getWeatherData;
    return MaterialApp(
      home: ChangeNotifierProvider<OMUProvider>(
        create: (ctx) => OMUProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("omu"),
            centerTitle: true,
          ),
          drawer: NavDrawer(),
          body: SlidingUpPanel(
            maxHeight: 700,
            minHeight: 200,
            onPanelOpened: () => {
              context.read<OMUProvider>().queryForecast(),
            },
            panel: Center(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        color: Color(0xffC4C4C4),
                        width: 350,
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Column(
                                children: [
                                  const Text("Wind Now",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(height: 5),
                                  const Icon(
                                    CupertinoIcons.wind,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      "${context.read<OMUProvider>().getWeatherData?.windSpeed}Km",
                                      style: TextStyle(fontSize: 25))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                children: [
                                  Text("Humidity",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(height: 5),
                                  Icon(
                                    CupertinoIcons.drop_fill,
                                    size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                      "${context.read<OMUProvider>().getWeatherData?.humidity}%",
                                      style: TextStyle(fontSize: 25))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                children: [
                                  Text("Precipitation",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(height: 5),
                                  Icon(
                                    CupertinoIcons.cloud_rain_fill,
                                    size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                      "${context.read<OMUProvider>().getWeatherData?.rainLastHour ?? "0%"}",
                                      style: TextStyle(fontSize: 25))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      color: Color(color),
                      width: 300,
                      height: 400,
                      child: Column(
                        children: [
                          // Image.asset(name)
                          SizedBox(height: 10),
                          Text("Weekly Weather",
                              style: TextStyle(fontSize: 15)),

                          ForecastList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // border:
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      color: Color(this.color),
                      width: 270,
                      height: 400,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(imageUrl, width: 170, height: 200),
                          Text(
                            context
                                    .read<OMUProvider>()
                                    .getWeatherData
                                    ?.areaName ??
                                "",
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            context
                                    .read<OMUProvider>()
                                    .getWeatherData
                                    ?.country ??
                                "",
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            formatTemperature(context
                                .read<OMUProvider>()
                                .getWeatherData
                                ?.temperature),
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(125, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "${formatTemperature(context.read<OMUProvider>().getWeatherData?.tempMin)} / ${formatTemperature(context.read<OMUProvider>().getWeatherData?.tempMax)}",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Widget cardImage(){
//
// }

}

class ForecastList extends StatelessWidget {
  const ForecastList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getWeekDay(DateTime t) {
      var date = t.toString();
      var newDate = DateTime.tryParse(date);
      date = DateFormat('EEEE').format(newDate!);
      return date;
    }

    String formatTemperature(Temperature? t) {
      String rawFormat = t.toString();
      String newFormat = rawFormat.substring(0, 4);
      newFormat += "℃";
      return newFormat;
    }

    Icon handleWeatherIcon() {
      return const Icon(Icons.cancel);
    }

    var val =
        context.read<OMUProvider>().getForecastList.map((idx) => print(idx));
    var forecastList = context.read<OMUProvider>().getForecastList;

    var prevDate = context.read<OMUProvider>().getForecastList[0].date;
    List newList = [];

    List handleForecastList() {
      for (var document in forecastList) {
        if (getWeekDay(document.date!) != getWeekDay(prevDate!)) {
          prevDate = document.date;

          newList.add(document);
        }
      }
      return newList;
    }

    handleForecastList();

    return Column(
      children: <Widget>[
        for (var document in newList)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 30.0,
                  width: 30,
                  child: Text(document.weatherIcon),
                  padding: const EdgeInsets.all(3.0)),
              Container(
                  height: 30.0,
                  child: Text(formatTemperature(document.temperature)),
                  padding: const EdgeInsets.all(3.0)),
              Container(
                  height: 30.0,
                  width: 80,
                  child: Text(getWeekDay(document.date)),
                  padding: const EdgeInsets.all(3.0)),
            ],
          ),
      ],
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Map'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapPage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Location List'),
            onTap: () => {
              OMUProvider().getSnapshotFromDb().whenComplete(() =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationListPage())))
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Timeline View'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebviewPage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              LoginAuthProvider().signOut().whenComplete(() => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage())))
            },
          ),
        ],
      ),
    );
  }
}
