import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'base_page.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  String age = '';
  String weight = '';
  int heartFailureLevel = 1;
  String selectedExercise = '';
  String exerciseTime = '';
  String errorMessage = '';
  List<String> exerciseHistory = [];
  Map<String, int> dailyExercise = {};

  @override
  void initState() {
    super.initState();
    _loadExerciseHistory();
  }

  Future<void> _loadExerciseHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/exercise_history.csv');
      if (await file.exists()) {
        final data = await file.readAsString();
        setState(() {
          exerciseHistory = data.split('\n');
          _calculateDailyExercise();
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load exercise history: $e';
      });
    }
  }

  void _calculateDailyExercise() {
    dailyExercise.clear();
    for (var entry in exerciseHistory) {
      if (entry.isNotEmpty) {
        final parts = entry.split(', ');
        final date = parts[0].split(' ')[0];
        final time = int.tryParse(parts[2].split(' ')[2]) ?? 0;

        if (dailyExercise.containsKey(date)) {
          dailyExercise[date] = dailyExercise[date]! + time;
        } else {
          dailyExercise[date] = time;
        }
      }
    }
  }

  void _saveExerciseHistory(String exerciseData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/exercise_history.csv');
      await file.writeAsString(exerciseData, mode: FileMode.append);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to save exercise history: $e';
      });
    }
  }

  List<String> _recommendExercises() {
    int ageValue = int.tryParse(age) ?? 0;
    List<String> recommendedExercises = [];

    if (ageValue >= 18 && ageValue <= 39) {
      if (heartFailureLevel == 1) {
        recommendedExercises = ['Walking', 'Stationary Cycling', 'Light Resistance Training (30-45 min)'];
      } else if (heartFailureLevel == 2) {
        recommendedExercises = ['Walking', 'Light Resistance', 'Chair Exercises (30 min)'];
      } else if (heartFailureLevel == 3) {
        recommendedExercises = ['Chair Exercises', 'Light Stretching', 'Slow Walking (15-20 min)'];
      } else if (heartFailureLevel == 4) {
        recommendedExercises = ['Chair Exercises', 'Slow Walking (10-15 min)'];
      }
    } else if (ageValue >= 40 && ageValue <= 59) {
      if (heartFailureLevel == 1) {
        recommendedExercises = ['Walking', 'Stationary Cycling', 'Light Resistance Training (30-45 min)'];
      } else if (heartFailureLevel == 2) {
        recommendedExercises = ['Walking', 'Light Resistance', 'Chair Exercises (30 min)'];
      } else if (heartFailureLevel == 3) {
        recommendedExercises = ['Chair Exercises', 'Light Stretching', 'Slow Walking (15-20 min)'];
      } else if (heartFailureLevel == 4) {
        recommendedExercises = ['Chair Exercises', 'Slow Walking (10-15 min)'];
      }
    } else if (ageValue >= 60) {
      if (heartFailureLevel == 1 || heartFailureLevel == 2) {
        recommendedExercises = ['Walking', 'Chair Exercises', 'Light Stretching (20-30 min)'];
      } else if (heartFailureLevel == 3) {
        recommendedExercises = ['Chair Exercises', 'Light Stretching (15 min)'];
      } else if (heartFailureLevel == 4) {
        recommendedExercises = ['Chair Exercises', 'Light Stretching (10-15 min)'];
      }
    }

    return recommendedExercises;
  }

  void _submitExerciseData() {
    if (exerciseTime.isEmpty || selectedExercise.isEmpty) {
      setState(() {
        errorMessage = 'Please fill out all fields';
      });
      return;
    }

    final exerciseData =
        '${DateTime.now()}, $selectedExercise, Exercise Time: $exerciseTime minutes\n';

    setState(() {
      exerciseHistory.add(exerciseData);
      _saveExerciseHistory(exerciseData);
      _calculateDailyExercise();
      errorMessage = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exercise data saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendedExercises = _recommendExercises();

    return BasePage(
      title: 'Exercise',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Enter Your Details',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
              ),
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
              ),
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: heartFailureLevel,
              dropdownColor: Colors.grey[900],
              onChanged: (int? newValue) {
                setState(() {
                  heartFailureLevel = newValue!;
                });
              },
              items: [1, 2, 3, 4].map<DropdownMenuItem<int>>((int level) {
                return DropdownMenuItem<int>(
                  value: level,
                  child: Text('Heart Failure Level $level', style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (recommendedExercises.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recommended Exercises:', style: TextStyle(fontSize: 20, color: Colors.white)),
                  for (var exercise in recommendedExercises)
                    RadioListTile<String>(
                      title: Text(exercise, style: TextStyle(color: Colors.white)),
                      value: exercise,
                      groupValue: selectedExercise,
                      onChanged: (String? value) {
                        setState(() {
                          selectedExercise = value!;
                        });
                      },
                    ),
                ],
              ),
            Divider(color: Colors.white),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Exercise Time (minutes)',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
              ),
              onChanged: (value) {
                setState(() {
                  exerciseTime = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitExerciseData,
              child: Text('Submit Exercise Data'),
            ),
            SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            Text(
              'Exercise History',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: exerciseHistory.length,
                itemBuilder: (context, index) {
                  return Text(
                    exerciseHistory[index],
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Daily Exercise Summary',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: dailyExercise.entries.map((entry) {
                    return BarChartGroupData(x: entry.key.hashCode, barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: entry.value.toDouble(),
                        color: Colors.blue,
                      ),
                    ]);
                  }).toList(),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}

