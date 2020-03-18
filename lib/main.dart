import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
import 'package:qrreaderapp/src/pages/mapa_page.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Reader',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'mapa': (BuildContext context) => MapaPage()
      },
      theme: ThemeData(primaryColor: Colors.blueGrey),
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 4,
        navigateAfterSeconds: HomePage(),
        title: Text(
          '\nQR Scanner',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        // image: Image.network('https://i.imgur.com/TyCSG9A.png'),
        image: Image.asset('assets/icon/QR.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}
