import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HayvanEkle extends StatefulWidget {
  const HayvanEkle({Key? key}) : super(key: key);

  @override
  _HayvanEkleState createState() => _HayvanEkleState();
}

class _HayvanEkleState extends State<HayvanEkle> {
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;

  User? loggedInUser;
  final ImagePicker _picker = ImagePicker();
  var imageFile = null;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  bool loading = false;
  createData() {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> hayvan = {
      "turu": turu,
      "cinsi": cinsi,
      'dogumtarihi': dogumtarihi,
      'cinsiyeti': cinsiyeti,
      'yavrusayisi': yavrusayisi,
      'irki': irki,
      'asilari': asilari,
      'kisirlastirma': kisirlastirma,
      'veteriner': veteriner,
      'hastaliklari': hastaliklari,
      'bulundugucografya': bulundugucografya,
      'foto': foto,
    };

    FirebaseFirestore.instance
        .collection('hayvanlar')
        .add(hayvan)
        .then((docRef) {
      setState(() {
        loading = false;
        qrData = docRef.id;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text('Hayvan Eklendi')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width - 100,
                child: QrImage(
                  padding: EdgeInsets.zero,
                  data: qrData,
                  version: QrVersions.auto,
                  gapless: true,
                ),
              ),
              Text('Hayvan ID: ' + qrData),
              Row(
                children: [
                  new FlatButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // dismisses only the dialog and returns nothing
                    },
                    child: Text('Panoya Kopyala'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Tamam'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
/*
   */
  }

  String? turu;
  String? cinsi;
  String? dogumtarihi;
  String? cinsiyeti;
  String? yavrusayisi;
  String? irki;
  String? asilari;
  String? kisirlastirma;
  String? veteriner;
  String? hastaliklari;
  String? bulundugucografya;
  String? foto;

  String qrData = "merhaba";
  var storage = FirebaseStorage.instance;

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return loading
            ? AlertDialog(
                content: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new CircularProgressIndicator(),
                    SizedBox(
                      width: 10,
                    ),
                    new Text("Oluşturuluyor"),
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      // flutter defined function
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Fotoğraf Yükleniyor"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Hayvan Ekle",
                style: TextStyle(
                    color: Colors.black87.withOpacity(0.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  turu = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Türü",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  cinsi = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Cinsi",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  dogumtarihi = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Doğum Tarihi",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  cinsiyeti = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Cinsiyeti",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  yavrusayisi = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Yavru Sayısı",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  irki = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Irkı",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  asilari = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Aşıları",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  kisirlastirma = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Kısırlaştırıldı mı",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  veteriner = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Sorumlu Veteriner",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  hastaliklari = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Hastalıkları",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  bulundugucografya = value;
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Bulunduğu Coğrafya",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(),
                color: Colors.orange,
                onPressed: () async {
                  final photo = await _picker.pickImage(
                      source: ImageSource.camera, imageQuality: 40);
                  File file = File(photo!.path);

                  if (file != null) {
                    setState(() {
                      _showDialog();
                    });
                    final _firebaseStorage = FirebaseStorage.instance;
                    //Upload to Firebase
                    var snapshot = await _firebaseStorage
                        .ref()
                        .child('images/imageName')
                        .putFile(file);
                    var downloadUrl =
                        await snapshot.ref.getDownloadURL().then((value) => {
                              setState(() {
                                foto = value;
                                print(value);

                                Navigator.pop(context);
                              })
                            });
                  } else {
                    print('No Image Path Received');
                  }
                },
                child: Text(
                  'Fotoğraf Çek',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                color: Colors.orange,
                onPressed: () async {
                  createData();
                  _onLoading();
                },
                child: Text(
                  'Hayvan Ekle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
