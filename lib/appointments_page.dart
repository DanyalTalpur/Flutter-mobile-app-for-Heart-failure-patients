import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final List<Map<String, String>> _appointments = [];

  void _addAppointment() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mrController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Appointment',
            style: TextStyle(color: Colors.purple),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Patient Name'),
                ),
                TextField(
                  controller: mrController,
                  decoration: InputDecoration(labelText: 'MR Number'),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: 'Time (e.g., 10:30 AM)'),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date (e.g., 2024-12-31)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.deepPurple)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    mrController.text.isNotEmpty &&
                    timeController.text.isNotEmpty &&
                    dateController.text.isNotEmpty) {
                  setState(() {
                    _appointments.add({
                      'name': nameController.text,
                      'mr': mrController.text,
                      'time': timeController.text,
                      'date': dateController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text('Add',
                style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Appointments Chart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _appointments.isEmpty
                  ? Center(
                child: Text(
                  'No Appointments',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  return Card(
                    color: Colors.purple,
                    child: ListTile(
                      title: Text(
                        'Name: ${appointment['name']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'MR#: ${appointment['mr']}\n'
                            'Time: ${appointment['time']}\n'
                            'Date: ${appointment['date']}',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAppointment,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
