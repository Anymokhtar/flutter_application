import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code;
        print('QR Code: $qrCode');
        updateStudentStatus();
      });
    });
  }

  void updateStudentStatus() async {
    String apiUrl = 'http://localhost:8080/etudiant/id/$qrCode'; // URL avec l'ID du code QR

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        body: {
          'status': 'present' // Remplacez 'nouveau_statut' par la valeur de statut que vous souhaitez mettre à jour
        },
      );

      if (response.statusCode == 200) {
        print('Statut de l\'étudiant mis à jour avec succès !');
      } else {
        print('Erreur lors de la mise à jour du statut de l\'étudiant. Code de statut : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour du statut de l\'étudiant : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Text('QR Code: $qrCode'),
        ],
      ),
    );
  }
}
