import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_tracker_app/models/semester.dart';
import 'package:grade_tracker_app/models/course.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> get _localFilePath async {
  final path = await _localPath;
  return '$path/data.json';
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.json');
}

class SemestersProvider extends ChangeNotifier {
  List<Semester> _semesters = [];
  int _semesterCount = 0;

  List<Semester> get semesters => _semesters;
  int get semesterCount => _semesterCount;

  Future<void> loadSemestersFromJson() async {
    final String response;
    final filePath = await _localFilePath;

    if (await File(filePath).exists()) {
      final file = await _localFile;
      response = await file.readAsString();
    } else {
      response = await rootBundle.loadString('assets/data.json');
    }

    final data = json.decode(response);
    _semesters = (data['semesters'] as List)
        .map((i) => Semester.fromJson(i))
        .toList();
    _semesterCount = _semesters.length;
    notifyListeners();
  }

  void addSemester(Semester semester) {
    _semesters.add(semester);
    _semesterCount++;
    notifyListeners();
  }

  void removeSemester(Semester semester) {
    if (_semesters.remove(semester)) {
      _semesterCount--;
      notifyListeners();
    }
  }

  double calculateCGPA() {
    double totalWeightedAverage = 0;
    double totalCourses = 0;
    for (var semester in _semesters) {
      for (var course in semester.courses) {
        totalWeightedAverage += course.calculateAverage() * course.weightage;
        totalCourses += course.weightage;
      }
    }
    return totalCourses > 0 ? totalWeightedAverage / totalCourses : 0;
  }

  void removeCourseFromSemester(String semesterId, Course course) {
    try {
      Semester foundSemester =
          _semesters.firstWhere((semester) => semester.id == semesterId);
      foundSemester.courses.remove(course);
      notifyListeners();
    } catch (e) {
      debugPrint("Semester not found: $semesterId");
    }
  }

  void changeSemesterId(String oldId, String newId) {
    try {
      Semester foundSemester =
          _semesters.firstWhere((semester) => semester.id == oldId);
      foundSemester.id = newId;
      notifyListeners();
    } catch (e) {
      debugPrint("Semester not found for ID update: $oldId");
    }
  }

  void updateCourseInSemester(String semesterId, Course updatedCourse) {
    try {
      Semester foundSemester =
          _semesters.firstWhere((semester) => semester.id == semesterId);
      int courseIndex = foundSemester.courses
          .indexWhere((course) => course.code == updatedCourse.code);
      if (courseIndex != -1) {
        foundSemester.courses[courseIndex] = updatedCourse;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Semester or course not found for update");
    }
  }
}
