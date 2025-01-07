import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentPage extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final Map<String, String> questions = {
    // Self-Care Management Questions
    'selfCareManagementQ1': 'Have you experienced any unusual symptoms today?',
    'selfCareManagementQ2': 'Have you taken your prescribed medication on time?',
    'selfCareManagementQ3': 'Have you felt shortness of breath today?',
    'selfCareManagementQ4': 'Have you felt dizzy or lightheaded today?',
    'selfCareManagementQ5': 'Have you had any swelling in your legs or feet?',
    'selfCareManagementQ6': 'Have you experienced chest pain or discomfort?',
    'selfCareManagementQ7': 'Have you noticed any irregular heartbeat?',
    'selfCareManagementQ8': 'Have you been able to sleep well at night?',

    // Self-Care Maintenance Questions
    'selfCareMaintenanceQ1': 'Have you followed your diet plan today?',
    'selfCareMaintenanceQ2': 'Did you exercise as recommended today?',
    'selfCareMaintenanceQ3': 'Did you avoid salty foods today?',
    'selfCareMaintenanceQ4': 'Did you drink enough water today?',
    'selfCareMaintenanceQ5': 'Did you avoid sugary drinks or snacks?',
    'selfCareMaintenanceQ6': 'Did you prepare your meals at home today?',
    'selfCareMaintenanceQ7': 'Have you avoided alcohol and smoking today?',
    'selfCareMaintenanceQ8': 'Have you taken breaks to relax or de-stress?',

    // Self-Care Monitoring Questions
    'selfCareMonitoringQ1': 'Have you checked your weight today?',
    'selfCareMonitoringQ2': 'Have you monitored your blood pressure today?',
    'selfCareMonitoringQ3': 'Have you checked your pulse today?',
    'selfCareMonitoringQ4': 'Did you track your fluid intake today?',
    'selfCareMonitoringQ5': 'Have you measured your blood sugar levels today?',
    'selfCareMonitoringQ6': 'Did you track your physical activity today?',
    'selfCareMonitoringQ7': 'Did you note any changes in your symptoms today?',
    'selfCareMonitoringQ8': 'Have you updated your health diary today?',
  };

  final Map<String, String> answers = {};

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      questions.forEach((key, _) {
        answers[key] = prefs.getString(key) ?? '';
      });
    });
  }

  Future<void> _saveAnswer(String key, String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, answer);
    setState(() {
      answers[key] = answer;
    });
  }

  void _viewPreviousRecords() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Previous Records'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: answers.entries
                  .where((entry) => entry.value.isNotEmpty)
                  .map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('${questions[entry.key]}: ${entry.value}'),
              ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionnaire(String title, List<String> questionKeys) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...questionKeys.map((key) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[key]!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: answers[key],
                    onChanged: (value) => _saveAnswer(key, value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your answer',
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Heart Failure Self-Care Assessment',
          style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Change to deepPurple
      ),
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => SingleChildScrollView(
                    child: _buildQuestionnaire(
                      'Self-Care Management',
                      [
                        'selfCareManagementQ1',
                        'selfCareManagementQ2',
                        'selfCareManagementQ3',
                        'selfCareManagementQ4',
                        'selfCareManagementQ5',
                        'selfCareManagementQ6',
                        'selfCareManagementQ7',
                        'selfCareManagementQ8',
                      ],
                    ),
                  ),
                ),
                child: Text('Self-Care Management'),
              ),
              ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => SingleChildScrollView(
                    child: _buildQuestionnaire(
                      'Self-Care Maintenance',
                      [
                        'selfCareMaintenanceQ1',
                        'selfCareMaintenanceQ2',
                        'selfCareMaintenanceQ3',
                        'selfCareMaintenanceQ4',
                        'selfCareMaintenanceQ5',
                        'selfCareMaintenanceQ6',
                        'selfCareMaintenanceQ7',
                        'selfCareMaintenanceQ8',
                      ],
                    ),
                  ),
                ),
                child: Text('Self-Care Maintenance'),
              ),
              ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => SingleChildScrollView(
                    child: _buildQuestionnaire(
                      'Self-Care Monitoring',
                      [
                        'selfCareMonitoringQ1',
                        'selfCareMonitoringQ2',
                        'selfCareMonitoringQ3',
                        'selfCareMonitoringQ4',
                        'selfCareMonitoringQ5',
                        'selfCareMonitoringQ6',
                        'selfCareMonitoringQ7',
                        'selfCareMonitoringQ8',
                      ],
                    ),
                  ),
                ),
                child: Text('Self-Care Monitoring'),
              ),
              ElevatedButton(
                onPressed: _viewPreviousRecords,
                child: Text('View Previous Records'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
