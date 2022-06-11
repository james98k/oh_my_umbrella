import 'dart:async';
// import 'dart:convert/convert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather/weather.dart';

import 'API/geoLocation.dart';
import 'API/weatherApi.dart';
import 'API/weather_functions.dart';
import 'API/Firebase.dart';

import 'firebase_options.dart';
import 'login_page.dart';
import 'main_page.dart';



// void main() async {
//   // runApp(MyApp());
//   runApp(const LoginPage());
//
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create : (_) => OMUProvider(),
        )

      ],
      child :  MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/main' : (context) => const MainPage(),
          '/login' : (context) => const LoginPage(),


          // '/': (context) => const]
        },

      ),
    )
    // ChangeNotifierProvider(
    //   create: (context) => ApplicationState(),
    //   // builder: (context) => const MainPage(),
    //   child:
    // ),
  );
}