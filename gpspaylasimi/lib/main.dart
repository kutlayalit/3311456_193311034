import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpsclient/qroku.dart';
import 'package:gpsclient/gps.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async{
  runApp(const MyApp());
  await Hive.initFlutter();

  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    readData().then((value) {
      if(value == ''){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRViewExample()),
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GPS()),
        );
      }
    });
  }

  String hayvan='';

  Future<String> readData() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    hayvan = sharedPreferences.getString("hayvanId") ?? '';
   return hayvan;
  }

  Future<void> saveData(String hayvan) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("hayvanId", hayvan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
