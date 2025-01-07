import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VitalSignsPage extends StatefulWidget {
  @override
  _VitalSignsPageState createState() => _VitalSignsPageState();
}

class _VitalSignsPageState extends State<VitalSignsPage> {
  List<Map<String, String>> vitalSigns = [];
  final _formKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final tempController = TextEditingController();
  final pulseController = TextEditingController();
  final bpSystolicController = TextEditingController();
  final bpDiastolicController = TextEditingController();
  final respRateController = TextEditingController();
  final oxygenSatController = TextEditingController();
  final commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVitalSigns();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    tempController.dispose();
    pulseController.dispose();
    bpSystolicController.dispose();
    bpDiastolicController.dispose();
    respRateController.dispose();
    oxygenSatController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  Future<void> _loadVitalSigns() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('vitalSigns');
    if (data != null) {
      setState(() {
        vitalSigns = List<Map<String, String>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveVitalSigns() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('vitalSigns', json.encode(vitalSigns));
  }

  void addVitalSign() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        vitalSigns.add({
          'date': dateController.text,
          'time': timeController.text,
          'temperature': tempController.text,
          'pulse': pulseController.text,
          'bloodPressure': '${bpSystolicController.text}/${bpDiastolicController.text}',
          'respiratoryRate': respRateController.text,
          'oxygenSaturation': oxygenSatController.text,
          'comments': commentsController.text,
        });
      });

      _saveVitalSigns(); // Save after adding the new entry

      // Clear the fields for the next entry
      dateController.clear();
      timeController.clear();
      tempController.clear();
      pulseController.clear();
      bpSystolicController.clear();
      bpDiastolicController.clear();
      respRateController.clear();
      oxygenSatController.clear();
      commentsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vital Signs',
          style: TextStyle(color: Colors.white), // Text color set to white
        ),
        backgroundColor: Colors.deepPurple, // Background color set to deep purple
      ),
      backgroundColor: Colors.deepPurple, // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Colors.white), // Label text color set to white
                ),
                style: TextStyle(color: Colors.white), // Input text color set to white
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
              ),
              TextFormField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tempController,
                decoration: InputDecoration(
                  labelText: 'Temperature (°F)',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the temperature';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: pulseController,
                decoration: InputDecoration(
                  labelText: 'Pulse (BPM)',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pulse rate';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: bpSystolicController,
                      decoration: InputDecoration(
                        labelText: 'Systolic BP (mmHg)',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter systolic BP';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: bpDiastolicController,
                      decoration: InputDecoration(
                        labelText: 'Diastolic BP (mmHg)',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter diastolic BP';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: respRateController,
                decoration: InputDecoration(
                  labelText: 'Respiratory Rate (breaths/min)',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the respiratory rate';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: oxygenSatController,
                decoration: InputDecoration(
                  labelText: 'Oxygen Saturation (%)',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter oxygen saturation';
                  }
                  if (int.tryParse(value) == null ||
                      int.parse(value) < 0 ||
                      int.parse(value) > 100) {
                    return 'Please enter a valid percentage (0-100)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: commentsController,
                decoration: InputDecoration(
                  labelText: 'Comments',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addVitalSign,
                child: Text('Add Entry'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomWebViewPage(url: 'http://192.168.4.1'),
                    ),
                  );
                },
                child: Text('Device Data'),
              ),
              SizedBox(height: 20),
              vitalSigns.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: vitalSigns.length,
                itemBuilder: (context, index) {
                  final vitalSign = vitalSigns[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${vitalSign['date']} - ${vitalSign['time']}',
                      ),
                      subtitle: Text(
                        'Temp: ${vitalSign['temperature']}°F\n'
                            'Pulse: ${vitalSign['pulse']} BPM\n'
                            'BP: ${vitalSign['bloodPressure']} mmHg\n'
                            'Respiratory Rate: ${vitalSign['respiratoryRate']} breaths/min\n'
                            'Oxygen Saturation: ${vitalSign['oxygenSaturation']}%\n'
                            'Comments: ${vitalSign['comments']}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            vitalSigns.removeAt(index);
                          });
                          _saveVitalSigns(); // Save after deletion
                        },
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No vital sign entries added yet.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomWebViewPage extends StatelessWidget {
  final String url;

  const CustomWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Data'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
      ),
    );
  }
}


