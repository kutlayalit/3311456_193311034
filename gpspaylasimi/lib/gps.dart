import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class GPS extends StatefulWidget {
  const GPS({Key? key}) : super(key: key);

  @override
  _GPSState createState() => _GPSState();
}

class _GPSState extends State<GPS> {
  String hayvan = '';
  String spHayvanId = '';
  String lat = '';
  String lon = '';
  void initState() {
    super.initState();
    runEveryMinute();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      runEveryMinute();
    });
  }

  runEveryMinute() {
    readData().then((data) {
      _determinePosition().then((value) {
        setState(() {
          lat  = value.latitude.toString();
          lon  = value.longitude.toString();
        });
        FirebaseFirestore.instance.collection('hayvanlar').doc(data).set({
          'enlem': value.latitude.toString(),
          'boylam': value.longitude.toString()
        }, SetOptions(merge: true)).then((value) {
          //Do your stuff.
        });
      });
    });
  }

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

  Future<String> readData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    hayvan = sharedPreferences.getString("hayvanId") ?? '';
    var box = await Hive.openBox('hayvanDB');
    String name = box.get('hayvanId') ?? '';
    print(name);
    return hayvan;
  }

  Future<void> saveData(String hayvan) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("hayvanId", hayvan);
    Box box1 = await Hive.openBox('hayvanDB');
    box1.put('hayvanId', hayvan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hayvan Takip GPS Servisi'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text('GPS Client', style: TextStyle(fontSize: 20),)),
          Center(child: Text('Hayvan ID: '+ spHayvanId, style: TextStyle(fontSize: 20),)),
          Center(child: Text('Enlem: '+ lat, style: TextStyle(fontSize: 20),)),
          Center(child: Text('Boylam: '+ lon, style: TextStyle(fontSize: 20),)),

        ],
      ),
    );
  }
}
