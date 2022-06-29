import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/allmap.dart';
import 'package:untitled1/hayvanekle.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/maps.dart';
import 'package:untitled1/model/speciality.dart';

import 'package:flutter/material.dart';
import 'package:untitled1/qrscanner.dart';

String selectedCategorie = "Genel Bilgiler";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;

  User? loggedInUser;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  List<String> categories = [
    "Genel Bilgiler",
    "Aşıları",
    "Hastalıkları",
  ];
  String hayvanid = '';
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

  String mainText =
      'Lütfen hayvanın kod numarasını girin veya barkodunu okutun';
  Map<String, dynamic> qwe = {};
  getData(String id) {
    FirebaseFirestore.instance
        .collection('hayvanlar')
        .doc(id)
        .snapshots()
        .first
        .then((value) {
      setState(() {
        turu = value.data()!['turu'];
        cinsi = value.data()!['cinsi'];
        dogumtarihi = value.data()!['dogumtarihi'];
        cinsiyeti = value.data()!['cinsiyeti'];
        yavrusayisi = value.data()!['yavrusayisi'];
        irki = value.data()!['irki'];
        asilari = value.data()!['asilari'];
        kisirlastirma = value.data()!['kisirlastirma'];
        veteriner = value.data()!['veteriner'];
        hastaliklari = value.data()!['hastaliklari'];
        bulundugucografya = value.data()!['bulundugucografya'];
        foto = value.data()!['foto'];

        isFound2 = true;
      });
      // asset = value.data()!['asset'];
    });
  }

  List<Widget> detaylar = [];
  bool isFound = false;
  bool isFound2 = false;
  TextEditingController aramaController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Giriş Yapan Kullanıcı: ' + loggedInUser!.email!,
                  style: TextStyle(color: Colors.orange, fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Hayvan Takip \nUygulaması",
                      style: TextStyle(
                          color: Colors.black87.withOpacity(0.8),
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    MaterialButton(
                      color: Colors.orange,
                      onPressed: () async {
                        Route route = MaterialPageRoute(
                            builder: (context) => HayvanEkle());
                        Navigator.push(context, route);
                      },
                      child: Text(
                        'Hayvan Ekle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      color: Colors.orange,
                      onPressed: () async {
                        Route route = MaterialPageRoute(
                            builder: (context) => TumHayvanlar());
                        Navigator.push(context, route);
                      },
                      child: Text(
                        'Hayvanları Haritada Gör',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aramaController,
                  onChanged: (value) {},
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.qr_code,
                              color: Colors.orange,
                            ),
                            onPressed: () async {
                              Route route = MaterialPageRoute(
                                  builder: (context) => QRViewExample());
                              var result = await Navigator.push(context, route);
                              hayvanid = result;
                              getData(result);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                getData(aramaController.text);
                              });
                            },
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.all(15),
                      filled: true,
                      fillColor: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.grey.shade700
                          : Color(0xFFF1F1F1),
                      hintText: "Numara veya Barkod",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                isFound2 == false
                    ? Text(
                        mainText,
                        style: TextStyle(
                            color: Colors.black87.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hayvan Bilgileri",
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.8),
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            color: Colors.orange,
                            onPressed: () async {
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      Harita(hayvanId: hayvanid));
                              Navigator.push(context, route);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Hayvanın Konumu',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 30,
                            child: ListView.builder(
                                itemCount: categories.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategorie = categories[index];
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      margin: EdgeInsets.only(left: 8),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: selectedCategorie ==
                                                categories[index]
                                            ? Color(0xffFFD0AA)
                                            : Colors.white,
                                      ),
                                      child: Text(
                                        categories[index],
                                        style: TextStyle(
                                            color: selectedCategorie ==
                                                    categories[index]
                                                ? Color(0xffFC9535)
                                                : Color(0xffA1A1A1)),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 250,
                            child: selectedCategorie == "Genel Bilgiler"
                                ? ListView(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        width: 175,
                                        margin: EdgeInsets.only(right: 16),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFBB97C),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 16, right: 16, left: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Genel Bilgiler',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              'Türü: ' + turu!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'Cinsi: ' + cinsi!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'Dogum Tarihi: ' + dogumtarihi!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'cinsiyeti: ' + cinsiyeti!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'yavrusayisi: ' + yavrusayisi!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'irki: ' + irki!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'kisirlastirma: ' +
                                                  kisirlastirma!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              'bulundugucografya: ' +
                                                  bulundugucografya!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 175,
                                        margin: EdgeInsets.only(right: 16),
                                        decoration: BoxDecoration(
                                          color: Color(0xffF69383),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 16, right: 16, left: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Hayvanın Fotoğrafları',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Image.network(
                                              foto!,
                                              fit: BoxFit.fitWidth,
                                              width: 170,
                                              height: 130,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : selectedCategorie == "Aşıları"
                                    ? ListView(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Container(
                                            width: 150,
                                            margin: EdgeInsets.only(right: 16),
                                            decoration: BoxDecoration(
                                              color: Color(0xffF69383),
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 16, right: 16, left: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Aşıları",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  asilari!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    : selectedCategorie == "Hastalıkları"
                                        ? ListView(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              Container(
                                                width: 150,
                                                margin:
                                                    EdgeInsets.only(right: 16),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF69383),
                                                ),
                                                padding: EdgeInsets.only(
                                                    top: 16,
                                                    right: 16,
                                                    left: 16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Hastalıkları',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      hastaliklari!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : SizedBox(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Sorumlu Veteriner",
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.8),
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/doctor_pic.png",
                                  height: 50,
                                ),
                                SizedBox(
                                  width: 17,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      veteriner!,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Uzman Veteriner",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 9),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFBB97C),
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Text(
                                    "Ara",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
