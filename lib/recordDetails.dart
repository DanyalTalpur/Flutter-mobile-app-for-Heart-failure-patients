import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordDetailsPage extends StatelessWidget {
  final String submissionDate;

  RecordDetailsPage({required this.submissionDate});

  Future<Map<String, String>> _getRecordDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'Breathlessness': prefs.getString('breathlessness') ?? '',
      'Chest Pain': prefs.getString('chestPain') ?? '',
      'Weight': prefs.getString('weight') ?? '',
      'Heart Rate': prefs.getString('heartRate') ?? '',
      'Blood Pressure Systolic': prefs.getString('bloodPressureSystolic') ?? '',
      'Blood Pressure Diastolic': prefs.getString('bloodPressureDiastolic') ?? '',
      'Appetite': prefs.getString('appetite') ?? '',
      'Ankle Swelling': prefs.getString('ankleSwelling') ?? '',
      'Fatigue': prefs.getString('fatigue') ?? '',
      'Weakness': prefs.getString('weakness') ?? '',
      'Coughing': prefs.getString('coughing') ?? '',
      'Cognitive Changes': prefs.getString('cognitiveChanges') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // Adjust bottom padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Record Details',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _getRecordDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading details'));
          }
          Map<String, String> recordDetails = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Add divider below the heading
              Divider(color: Colors.white, thickness: 2),
              // Map record entries to widgets
              ...recordDetails.entries.map((entry) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${entry.key}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 2,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Add space between divider and answer
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Adjust vertical padding
                            child: Text(
                              '${entry.value}',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.white, thickness: 2),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
