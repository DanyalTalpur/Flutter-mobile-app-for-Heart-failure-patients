import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import for notifications
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:timezone/data/latest.dart' as tz; // Import for time zone data
import 'package:timezone/timezone.dart' as tz; // Import for time zone handling

import 'base_page.dart'; // Import BasePage

class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final List<Map<String, dynamic>> _medications = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); // Initialize notifications plugin

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Initialize notifications
  }

  void _initializeNotifications() {
    tz.initializeTimeZones(); // Initialize time zones

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleNotification(String medicineName, DateTime time) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'medication_reminder',
      'Medication Reminder',
      channelDescription: 'Remind to take medication',
      importance: Importance.high,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to take your medicine',
      '$medicineName is due',
      tz.TZDateTime.from(time, tz.local), // Schedule the notification with the correct time zone
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _addMedication(String name, int quantity, DateTime time) {
    setState(() {
      _medications.add({
        'name': name,
        'quantity': quantity,
        'time': time,
      });
    });
    _scheduleNotification(name, time); // Schedule a notification
  }

  // Show dialog for adding a new medication
  void _showAddMedicineDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    DateTime selectedTime = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Medication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Medicine Name'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    selectedTime = DateTime(now.year, now.month, now.day,
                        pickedTime.hour, pickedTime.minute);
                  }
                },
                child: Text('Pick Time'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final String name = nameController.text;
                final int quantity = int.parse(quantityController.text);
                _addMedication(name, quantity, selectedTime);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to view previous medication data
  void _viewPreviousMedications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Previous Medications'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _medications.map((medication) {
              return ListTile(
                title: Text('${medication['name']}'),
                subtitle: Text(
                    'Quantity: ${medication['quantity']}, Time: ${DateFormat('hh:mm a').format(medication['time'])}'),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Medication Diary',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final medication = _medications[index];
                return ListTile(
                  title: Text('${medication['name']}'),
                  subtitle: Text(
                      'Quantity: ${medication['quantity']} \nTime: ${DateFormat('hh:mm a').format(medication['time'])}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showAddMedicineDialog,
              child: Text('Add medication to diary'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _viewPreviousMedications, // View previous medications
              child: Text('View Previous Medications'),
            ),
          ),
        ],
      ),
    );
  }
}




