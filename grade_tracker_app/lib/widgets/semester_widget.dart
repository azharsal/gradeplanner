// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:grade_tracker_app/models/course.dart';
import 'package:grade_tracker_app/models/semester.dart';
import 'package:grade_tracker_app/providers/semester_provider.dart';
import 'package:grade_tracker_app/widgets/course_widget.dart';
import 'package:provider/provider.dart';

class SemesterWidget extends StatefulWidget {
  Semester semester;
  SemesterWidget({required this.semester});

  @override
  _SemesterWidgetState createState() => _SemesterWidgetState();
}

class _SemesterWidgetState extends State<SemesterWidget> {
  @override
  Widget build(BuildContext context) {
    Semester semester = widget.semester;
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('Semester ${widget.semester.id}')),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      // Your existing ListView.builder for courses

      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: semester.courses.length,
          itemBuilder: (context, index) {
            final course = semester.courses[index];
            return CourseWidget(course: course);
          },
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String courseName = '';
                String courseId = '';
                String creditWeightage = '';

                return AlertDialog(
                  title: const Text('Add Course'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) => courseName = value,
                        decoration: const InputDecoration(labelText: 'Course Name'),
                      ),
                      TextField(
                        onChanged: (value) => courseId = value,
                        decoration: const InputDecoration(labelText: 'Course ID'),
                      ),
                      TextField(
                        onChanged: (value) => creditWeightage = value,
                        decoration:
                            const InputDecoration(labelText: 'Credit Weightage'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (courseName.isNotEmpty &&
                            courseId.isNotEmpty &&
                            creditWeightage.isNotEmpty) {
                          Course course = Course(
                            name: courseName,
                            code: courseId,
                            semesterId: semester.id,
                            weightage: (double.tryParse(creditWeightage)) != null
                              ? double.parse(creditWeightage)
                              : 0.5 ,
                            assessments: [],
                            totalGrade: 0,
                            gradeToDate: 0,
                          );
                          setState(() {
                            widget.semester.courses.add(course);
                          });
                          Navigator.of(context).pop();
                        } else {
                          // Show a snackbar or alert indicating fields are required
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter all fields.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Add'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Add Course'),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    switch (value) {
      case 'edit':
        _showEditSemesterDialog(context);
        break;
      case 'delete':
        _confirmDeletion(context);
        break;
    }
  }

  void _showEditSemesterDialog(BuildContext context) {
    TextEditingController idController =
        TextEditingController(text: widget.semester.id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Semester"),
          content: TextField(
            controller: idController,
            decoration: const InputDecoration(labelText: "Semester ID"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                final newId = idController.text;
                Provider.of<SemestersProvider>(context, listen: false)
                    .changeSemesterId(widget.semester.id, newId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this semester?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Provider.of<SemestersProvider>(context, listen: false)
                    .removeSemester(widget.semester);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}