import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/register.dart';
import 'package:untitled1/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_charts/flutter_charts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void initState() {
    super.initState();
    getCurrentUser();
    baslik().then((value) {
      setState(() {
        title = value;
      });
    });
  }

  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;

  String? _content;

  // Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // This function is triggered when the "Read" button is pressed
  Future<void> _readData() async {
    final dirPath = await _getDirPath();
    final myFile = File('$dirPath/data.txt');
    final data = await myFile.readAsString(encoding: utf8).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Gesture, okunan veri: ' + value.toString()),
      ));
    });
  }

  Future<void> _writeData() async {
    final _dirPath = await _getDirPath();

    final _myFile = File('$_dirPath/data.txt');

    await _myFile.writeAsString('a', mode: FileMode.append);
  }

  Future<String> baslik() async {
    final response = await http
        .get(Uri.parse('https://api.jsonbin.io/b/62b77c8a449a1f38211afc4c'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["title"];
    } else {
      return 'http okuma hatasi';
    }
  }

  String title = '';

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.push(context, route);
      }
    } catch (e) {
      print(e);
    }
  }

  final snackBar = SnackBar(
    content: Text('Gesture Çalıştı'),
  );

  @override
  Widget build(BuildContext context) {
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
              GestureDetector(
                onTap: () {
                  _writeData().then((value) {
                    _readData();
                  });
                },
                onSecondaryLongPress: () {
                  _writeData().then((value) {
                    _readData();
                  });
                },
                onLongPressCancel: () {
                  _writeData().then((value) {
                    _readData();
                  });
                },
                onLongPress: () {
                  _writeData().then((value) {
                    _readData();
                  });
                },
                onSecondaryTap: () {
                  _writeData().then((value) {
                    _readData();
                  });
                },
                child: LoopAnimation<double>(
                  tween: Tween(begin: 20.0, end: 80.0),
                  curve: Curves.easeInOut,
                  duration: const Duration(seconds: 3),
                  builder: (context, child, value) {
                    return Image.asset(
                      "assets/logo.png",
                      width: value,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Giriş Yap\n",
                style: TextStyle(
                    color: Colors.black87.withOpacity(0.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                onChanged: (value) {},
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Kullanıcı Adı",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {},
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey.shade700
                        : Color(0xFFF1F1F1),
                    hintText: "Şifre",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email!, password: password!);
                        if (user != null) {
                          Route route = MaterialPageRoute(
                              builder: (context) => HomePage());
                          Navigator.push(context, route);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Giriş Yap'),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Route route =
                          MaterialPageRoute(builder: (context) => Register());
                      Navigator.push(context, route);
                    },
                    child: Text('Kayıt Ol'),
                  ),
                ],
              ),
              Container(height: 300, width: 300, child: chartToRun()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget chartToRun() {
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();
  // Example shows an explicit use of the DefaultIterativeLabelLayoutStrategy.
  // The xContainerLabelLayoutStrategy, if set to null or not set at all,
  //   defaults to DefaultIterativeLabelLayoutStrategy
  // Clients can also create their own LayoutStrategy.
  xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
    options: chartOptions,
  );
  chartData = ChartData(
    dataRows: const [
      [10.0, 20.0, 5.0, 30.0, 5.0, 20.0],
      [30.0, 60.0, 16.0, 100.0, 12.0, 120.0],
      [25.0, 40.0, 20.0, 80.0, 12.0, 90.0],
      [12.0, 30.0, 18.0, 40.0, 10.0, 30.0],
    ],
    xUserLabels: const ['Wolf', 'Deer', 'Owl', 'Mouse', 'Hawk', 'Vole'],
    dataRowsLegends: const [
      'Spring',
      'Summer',
      'Fall',
      'Winter',
    ],
    chartOptions: chartOptions,
  );
  // chartData.dataRowsDefaultColors(); // if not set, called in constructor
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );
  return lineChart;
}
