import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_data.dart';

class PatientPage extends StatefulWidget {
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> patients = [];
  Map<String, String>? searchedPatient;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query('patients');

    setState(() {
      patients = List.generate(maps.length, (i) {
        return {
          'name': maps[i]['name'],
          'medicalRecordNumber': maps[i]['medicalRecordNumber'],
        };
      });
    });
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'patients_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE patients(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, medicalRecordNumber TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insertPatient(Map<String, String> patient) async {
    final Database db = await _openDatabase();
    await db.insert(
      'patients',
      {'name': patient['name']!, 'medicalRecordNumber': patient['medicalRecordNumber']!},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadPatients();
  }

  void _searchPatient() {
    final medicalRecordNumber = _searchController.text;
    if (medicalRecordNumber.isNotEmpty) {
      final patient = UserData.getUserDataByMedicalRecordNumber(medicalRecordNumber);
      if (patient != null && patient.isNotEmpty) {
        setState(() {
          searchedPatient = patient;
        });
        _insertPatient(searchedPatient!);
      } else {
        setState(() {
          searchedPatient = null;
        });
      }
    }
  }

  void _removePatient(int index) async {
    final Database db = await _openDatabase();
    await db.delete(
      'patients',
      where: 'medicalRecordNumber = ?',
      whereArgs: [patients[index]['medicalRecordNumber']],
    );
    setState(() {
      patients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Patients'),
      ),
      body: Container(
        color: Colors.deepPurple,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Medical Record Number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchPatient,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            if (searchedPatient != null)
              ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    // Handle navigation to patient detail page
                  },
                  child: Text(
                    searchedPatient!['name']!,
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200, 60),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        // Handle navigation to patient detail page
                      },
                      child: Text(
                        patient['name']!,
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(200, 60),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removePatient(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
