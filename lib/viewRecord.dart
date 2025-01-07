import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recordDetails.dart';

class PreviousRecordsPage extends StatelessWidget {
  Future<List<String>> _getSubmissionDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('submissionDates') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Previous Records',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: _getSubmissionDates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading records'));
          }
          List<String> submissionDates = snapshot.data!;
          return ListView.builder(
            itemCount: submissionDates.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      submissionDates[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordDetailsPage(submissionDate: submissionDates[index]),
                        ),
                      );
                    },
                  ),
                  Divider(color: Colors.white, thickness: 2),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

