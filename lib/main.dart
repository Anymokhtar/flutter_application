import 'package:flutter/material.dart';
import 'login_page.dart';
import 'code_qr.dart';
import 'search_etudiant.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/code_qr': (context) => CodeQrPage(),
        '/rechercher_etudiant': (context) => SearcheEtudiant(),
        '/login' : (context) => LoginPage()
      },
    );
  }
}