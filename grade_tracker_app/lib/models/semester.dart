import 'package:grade_tracker_app/models/course.dart';

class Semester {
  String id;
  List<Course> courses;

  Semester({required this.id, required this.courses});

  factory Semester.fromJson(Map<String, dynamic> json) {
    var coursesList = json['courses'] as List;
    List<Course> courseObjects =
        coursesList.map((i) => Course.fromJson(i)).toList();

    return Semester(
      id: json['id'],
      courses: courseObjects,
    );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'courses' : courses.map((i) => i.toJson()).toList(),
  };
}
