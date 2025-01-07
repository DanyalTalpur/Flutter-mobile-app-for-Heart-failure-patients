import 'package:flutter/material.dart';
import 'assessment_page.dart';
import 'chatbot.dart';
import 'exercise_page.dart';
import 'instruction_page.dart';
import 'medicine_page.dart';
import 'vital_sign_page.dart';
import 'user_data.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HealthInterventionPage extends StatelessWidget {
  final String userEmail;

  HealthInterventionPage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    Map<String, String>? userData = UserData.getUserData(userEmail);
    if (userData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Heart Intervention'),
        ),
        body: Center(
          child: Text('User data not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Heart Intervention',
          style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Medical Record No: ${userData['medicalRecordNumber']!}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userEmail: userEmail),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.deepPurple,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Divider(
                  color: Colors.white,
                  thickness: 2,
                  indent: 16,
                  endIndent: 16,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ResponsiveButtonRow(
                          buttons: [
                            _buildButton(context, 'Assessment', Icons.assignment, AssessmentPage()),
                            _buildButton(context, 'Exercise', Icons.fitness_center, ExercisePage()),
                            _buildButton(context, 'Vital Signs', Icons.favorite, VitalSignsPage()),
                          ],
                        ),
                        SizedBox(height: 16),
                        ResponsiveButtonRow(
                          buttons: [
                            _buildButton(context, 'Medicine', Icons.medication, MedicinePage()),
                            _buildButton(context, 'Instructions', Icons.info, InstructionPage()),
                            _buildButton(context, 'Chatbot', Icons.chat, ChatbotPage()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, Widget page) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      icon: Icon(icon, color: Colors.black, size: 32),
      label: Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(100, 60),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }
}

class ResponsiveButtonRow extends StatelessWidget {
  final List<Widget> buttons;

  ResponsiveButtonRow({required this.buttons});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 600) {
      // Stack buttons vertically on smaller screens
      return Column(
        children: buttons.map((button) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: button,
        )).toList(),
      );
    } else {
      // Arrange buttons in a row on larger screens
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      );
    }
  }
}
