import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gps.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {

  void initState() {
    super.initState();
  readData();
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
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                          'Bitki ID: ${result!.code}'),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: const Text('Barkodu okutun'),
                    ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) {},
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {

      setState(() {

        result = scanData;
        saveData(result!.code!).then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GPS()),
          );
        });
      });
      controller.stopCamera();

    });
  }



  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}