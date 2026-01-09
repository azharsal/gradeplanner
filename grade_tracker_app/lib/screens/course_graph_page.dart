import 'package:flutter/material.dart';
import 'package:grade_tracker_app/models/assessment_grade.dart';
import 'package:grade_tracker_app/models/course.dart';
import 'package:grade_tracker_app/widgets/lineChart.dart';

class CourseGraphPageWidget extends StatefulWidget {
  final Course course;
  const CourseGraphPageWidget({super.key, required this.course});

  @override
  State<CourseGraphPageWidget> createState() => _CourseGraphPageWidgetState();
}

class _CourseGraphPageWidgetState extends State<CourseGraphPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: const Color.fromARGB(230, 255, 255, 255),
        title: Text(
          widget.course.code,
          style: const TextStyle(
            color: Color.fromARGB(230, 255, 255, 255),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: LineChartWidget(widget.course, getGradeList(widget.course)),
    );
  }
}
