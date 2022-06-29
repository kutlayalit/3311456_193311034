import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Harita extends StatefulWidget {
  Harita({required this.hayvanId});
  String hayvanId;
  @override
  _HaritaState createState() => _HaritaState();
}



class _HaritaState extends State<Harita> {
  void initState() {
    super.initState();


  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:  FirebaseFirestore.instance
          .collection('hayvanlar').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data!.docs.first;
                print((doc['enlem']) + (doc['boylam']));

              return  Expanded(
                child: GoogleMap(
                  markers: {
                    Marker(

                      markerId: MarkerId(widget.hayvanId),
                      position: LatLng(double.parse(doc['enlem']), double.parse(doc['boylam'])),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(doc['enlem']), double.parse(doc['boylam'])),
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
