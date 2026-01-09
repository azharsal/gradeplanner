//main screen big parent widget
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:grade_tracker_app/models/semester.dart';
import 'package:grade_tracker_app/providers/semester_provider.dart';
import 'package:grade_tracker_app/widgets/semester_widget.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text('Grade Tracker', 
            style: TextStyle(
              color: Color.fromARGB(230, 255, 255, 255), 
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        actions: [
            InvertColors(
              child: Image.asset('assets/logo.png', height: 70),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
              child: Consumer<SemestersProvider>(
                builder: (_, provider, __) =>
                Text('CGPA: ${provider.calculateCGPA().toStringAsFixed(2)}', 
                    style: const TextStyle(
                      color: Color.fromARGB(230, 255, 255, 255), 
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            

          
        ],
        backgroundColor: Colors.teal,
        foregroundColor: const Color.fromARGB(230, 255, 255, 255),



        
      ),
      body: Consumer<SemestersProvider>(
        builder: (context, semestersProvider, _) => ListView.separated(
          itemCount: semestersProvider.semesters.length,
          itemBuilder: (context, index) {
            final semester = semestersProvider.semesters[index];
            return SemesterWidget(semester: semester);
          },
          separatorBuilder: (context, index) =>
              const Divider(height: 1), // Customize your separator here
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog is used to show a popup dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Temporary variable to hold the semester name
              String semesterName = '';

              return AlertDialog(
                title: const Text('Add Semester'),
                content: TextField(
                  onChanged: (value) {
                    semesterName = value;
                  },
                  decoration: const InputDecoration(hintText: "Enter semester name"),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (semesterName.isNotEmpty) {
                        // If the user has entered a name, add the semester
                        final semestersProvider =
                            Provider.of<SemestersProvider>(context,
                                listen: false);
                        semestersProvider.addSemester(
                            Semester(id: semesterName, courses: []));
                        Navigator.of(context).pop(); // Close the dialog
                      } else {
                        // Optionally handle the case where no name is entered
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}