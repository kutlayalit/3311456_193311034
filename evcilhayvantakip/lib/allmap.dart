import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TumHayvanlar extends StatefulWidget {
  TumHayvanlar();

  @override
  _TumHayvanlarState createState() => _TumHayvanlarState();
}

class _TumHayvanlarState extends State<TumHayvanlar> {
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/dog.png')
        .then((onValue) {
      myIcon = onValue;
      setState(() {
        isLoading = false;
      });
    });
  }

  BitmapDescriptor? myIcon;

  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 30);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  bool isLoading = true;

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};

    return Scaffold(
      body: isLoading
          ? Column()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('hayvanlar')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DocumentSnapshot doc = snapshot.data!.docs[0];

                      try {
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          if (snapshot.data!.docs[i]['enlem'] != null) {
                            markers.add(
                              Marker(
                                markerId: MarkerId('asdsad'),
                                position: LatLng(
                                    double.parse(
                                        snapshot.data!.docs[i]['enlem']),
                                    double.parse(
                                        snapshot.data!.docs[i]['boylam'])),
                                icon: myIcon!,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                      return Expanded(
                        child: GoogleMap(
                          markers: markers,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(double.parse(doc['enlem']),
                                double.parse(doc['boylam'])),
                            zoom: 14.4746,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      );
                    } else {
                      return Text("No data");
                    }
                  },
                )
              ],
            ),
    );
  }
}
