import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/code_qr');
              },
              icon: FaIcon(FontAwesomeIcons.qrcode), 
              label: Text('Scanner Code QR'),
              backgroundColor: Colors.blue,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/rechercher_etudiant');
              },
              icon: FaIcon(FontAwesomeIcons.search),
              label: Text('Rechercher Etudiant'),
              backgroundColor: Colors.blue,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
              label: Text('Déconnexion'),
              backgroundColor: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}