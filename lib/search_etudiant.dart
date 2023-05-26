import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Student {
  final int id;
  final String cne;
  final String nom;
  final String prenom;
  final String email;
  final String filiere;
  final String niveau;
  final String groupe;
  String status;

  Student({
    required this.id,
    required this.cne,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.filiere,
    required this.niveau,
    required this.groupe,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      cne: json['cne'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      filiere: json['filiere'],
      niveau: json['niveau'],
      groupe: json['groupe'],
      status: json['status'],
    );
  }
}

class StudentService {
  final Dio dio;

  StudentService() : dio = Dio();

  Future<Student> fetchStudentByCne(String cne) async {
    final response = await dio.get('https://d970-41-141-220-87.ngrok-free.app/etudiant/cne/$cne');
    if (response.statusCode == 200) {
      final data = response.data;
      return Student(
        id: data['id'],
        cne: data['cne'],
        nom: data['nom'],
        prenom: data['prenom'],
        email: data['email'],
        filiere: data['filiere'],
        niveau: data['niveau'],
        groupe: data['groupe'],
        status: data['status'],
      );
    } else if (response.statusCode == 404) {
      throw Exception('Étudiant non trouvé');
    } else {
      throw Exception('Échec du chargement de l\'étudiant');
    }
  }

  Future<void> updateStudentStatus(int studentId) async {
    final response = await dio.put(
      'https://d970-41-141-220-87.ngrok-free.app/etudiant/id/$studentId',
      data: {'status': 'présent'},
    );
    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour du statut de l\'étudiant');
    }
  }
}

class SearcheEtudiant extends StatefulWidget {
  @override
  _SearchEtudiantState createState() => _SearchEtudiantState();
}

class _SearchEtudiantState extends State<SearcheEtudiant> {
  final TextEditingController _cneController = TextEditingController();
  int _studentId = 0;
  final StudentService studentService = StudentService();

  Future<Student> fetchStudentByCne(String cne) =>
      studentService.fetchStudentByCne(cne);

  Future<void> updateStudentStatus() =>
      studentService.updateStudentStatus(_studentId);

  @override
  void dispose() {
    _cneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche étudiant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: _cneController,
              decoration: InputDecoration(
                hintText: 'Entrez le CNE de l\'étudiant',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () async {
                final cne = _cneController.text.trim();
                if (cne.isNotEmpty) {
                  try {
                    final student = await fetchStudentByCne(cne);
                    setState(() {
                      _studentId = student.id;
                    });
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Étudiant non trouvé'),
                        content:
                            Text('Aucun étudiant trouvé avec le CNE donné.'),
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
              },
              icon: Icon(Icons.search),
              label: Text('Rechercher'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (_studentId != 0)
              FutureBuilder(
                future: fetchStudentByCne(_cneController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final student = snapshot.data as Student;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nom : ${student.nom}',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Prénom : ${student.prenom}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'CNE : ${student.cne}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'E-mail : ${student.email}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Filière : ${student.filiere}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Niveau : ${student.niveau}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Groupe : ${student.groupe}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Statut : ${student.status}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: student.status == 'absent'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            try {
                              updateStudentStatus();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Statut mis à jour'),
                                  content: Text(
                                      'Le statut de l\'étudiant a été mis à jour.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              );
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      Text('Échec de la mise à jour du statut'),
                                  content: Text(
                                      'Échec de la mise à jour du statut de l\'étudiant.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.check),
                          label: Text('Marquer présent'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return SizedBox();
                },
              )
          ],
        ),
      ),
    );
  }
}
