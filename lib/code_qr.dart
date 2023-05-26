import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Etudiant {
  final int id;
  String status;

  Etudiant({required this.id, required this.status});
}

class APIService {
  final Dio dio = Dio();

  Future<void> updateStudentStatus(Etudiant etudiant, BuildContext context) async {
    try {
      final response = await dio.put(
        'https://d970-41-141-220-87.ngrok-free.app/etudiant/id/${etudiant.id}',
        data: {'status': etudiant.status},
      );
      if (response.statusCode != 200) {
        throw Exception('Échec de la mise à jour du statut de l\'étudiant');
      }
    } on DioError catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Une erreur s\'est produite : ${e.message}'),
        ),
      );
    }
  }
}

class CodeQrPage extends StatefulWidget {
  @override
  _CodeQrPageState createState() => _CodeQrPageState();
}

class _CodeQrPageState extends State<CodeQrPage> {
  String _scannedCode = '';

  Future<void> _scanCode() async {
    try {
      final String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 
        'Annuler', 
        true, 
        ScanMode.QR,
      );
      if (result != '-1') {
        setState(() {
          _scannedCode = result;
        });
        final etudiant = Etudiant(id: int.parse(_scannedCode), status: 'présent');
        APIService().updateStudentStatus(etudiant, context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Statut de l\'étudiant mis à jour'),
            content: Text('Le statut de l\'étudiant a été mis à jour avec succès.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    } on FormatException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur de format'),
          content: Text('Le code scanné n\'est pas un nombre : $e'),
        ),
      );
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
