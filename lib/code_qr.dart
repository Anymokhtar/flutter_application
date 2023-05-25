import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dio/dio.dart';

class CodeQrPage extends StatefulWidget {
  @override
  _CodeQrPageState createState() => _CodeQrPageState();
}

class _CodeQrPageState extends State<CodeQrPage> {
  final Dio dio = Dio();
  String _scannedCode = '';

  Future<void> _scanCode() async {
    try {
      final String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Couleur de la barre de numérisation
        'Annuler', // Texte du bouton d'annulation
        true, // Utiliser la caméra arrière par défaut
        ScanMode.QR, // Numériser uniquement les codes QR
      );
      if (result != '-1') {
        setState(() {
          _scannedCode = result;
        });
        // Appeler la méthode d'API pour mettre à jour le statut de l'étudiant en utilisant _scannedCode
        await updateStudentStatus(int.parse(_scannedCode));
      }
    } catch (e) {
      // Gérer les erreurs liées au scan du code QR ou du code-barres
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur de numérisation'),
          content: Text('Une erreur s\'est produite lors de la numérisation du code.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  Future<void> updateStudentStatus(int studentId) async {
    final response = await dio.put(
      'http://localhost:8080/etudiant/id/$studentId',
      data: {'status': 'présent'},
    );
    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour du statut de l\'étudiant');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner de Code QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: _scanCode,
          )
        ],
      ),
      body: Center(
        child: FloatingActionButton.extended(
          onPressed: _scanCode,
          icon: Icon(Icons.qr_code_scanner), 
          label: Text('Scanner'),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
