import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oh_my_umbrella/API/weather_functions.dart';
import 'package:provider/provider.dart';


class LocationListPage extends StatefulWidget{

  const LocationListPage({Key? key}): super(key : key);

  @override
  _LocationListPage createState()=> _LocationListPage();


}

class _LocationListPage extends State<LocationListPage>{
  @override
  Widget build(BuildContext context) {

    // var locationList = context.read<OMUProvider>().getLocationInfoList;
    // print("=============location List");

    print(context.read<OMUProvider>().getLocationInfoList[0].locationName);
    var newLocationList = context.read<OMUProvider>().getLocationInfoList;
    newLocationList = newLocationList.sublist(0,10);

    String handleTimestamp(int timestamp){
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateFormat _dateFormat = DateFormat('MM-dd HH:mm:ss');

      String formattedDate = _dateFormat.format(date);
      return formattedDate;
    }

    return MaterialApp(
      home : ChangeNotifierProvider<OMUProvider>(
        create: (ctx) => OMUProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ooooomu"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: ()=>{
                Navigator.pop(context)
              },
            ),
          ),

          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(

                  children: [
                    Text("hello worldf"),
                    for (var document in newLocationList)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(height: 50.0, width: 30, child: Icon(Icons.location_pin)),
                          Container(height: 50.0, child:  Text(
                            // handleGetAddressNameByPosition(document.latitude!, document.longitude!),
                            "${document.locationName}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15
                            ),
                          ), padding: const EdgeInsets.all(3.0)),
                          Container(height : 50.0, width : 130, child: Text("${handleTimestamp(document.timestamp)}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15
                            ),

                          ), padding: const EdgeInsets.all(3.0)),


                        ],
                      ),
                  ],

                ),
              )
            ],
          )
        ),
      )
    );
  }

}

class LocationList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var locationList = context.read<OMUProvider>().getLocationInfoList;

    // List<OMUProvider().getLocationInfoList> locationList = locationLLList;

    String handleGetAddressNameByPosition(double lat, double  long){

      String name = OMUProvider().getAddressFromLatLong(lat, long) as String;
      print(name);
      return name;
    }

    return Column(
      children: <Widget>[


      ],
    );
  }
}