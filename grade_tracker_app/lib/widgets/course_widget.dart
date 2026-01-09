import 'package:flutter/material.dart';
import 'package:grade_tracker_app/models/course.dart';
import 'package:grade_tracker_app/providers/semester_provider.dart';
import 'package:grade_tracker_app/screens/course_detail_page.dart';
import 'package:provider/provider.dart';

class CourseWidget extends StatefulWidget {
  final Course course;
  const CourseWidget({super.key, required this.course});

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.course.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Avg: ${widget.course.calculateAverage().toStringAsFixed(2)}   '),
            Text('Weightage: ${widget.course.weightage.toString()}'),
            PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleMenuAction(context, value, widget.course),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursePageWidget(course: widget.course),
            ),
          );
        },
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value, Course course) {
    if (value == 'edit') {
      _showEditCourseDialog(context, course);
    } else if (value == 'delete') {
      _confirmCourseDeletion(context, course);
    }
  }

  void _showEditCourseDialog(BuildContext context, Course course) {
    TextEditingController nameController =
        TextEditingController(text: course.name);
    TextEditingController weightageController =
        TextEditingController(text: course.weightage.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Course"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Course Name"),
                ),
                TextField(
                  controller: weightageController,
                  decoration: const InputDecoration(labelText: "Weightage"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                final updatedCourse = Course(
                  name: nameController.text,
                  code: course.code,
                  semesterId: course.semesterId,
                  weightage: (double.tryParse(weightageController.text) != null)
                      ? double.parse(weightageController.text)
                      : 0.5,
                  assessments: course.assessments,
                  totalGrade: course.totalGrade,
                  gradeToDate: course.gradeToDate,
                );
                Provider.of<SemestersProvider>(context, listen: false)
                    .updateCourseInSemester(widget.course.semesterId, updatedCourse);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmCourseDeletion(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this course?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Provider.of<SemestersProvider>(context, listen: false)
                    .removeCourseFromSemester(course.semesterId, course);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
