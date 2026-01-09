import 'package:grade_tracker_app/models/assessment.dart';

class Course {
  String name;
  String code;
  String semesterId;
  double weightage;
  List<Assessment> assessments;
  double totalGrade;
  double gradeToDate;

  Course({
    required this.name,
    required this.code,
    required this.semesterId,
    required this.weightage,
    required this.assessments,
    required this.totalGrade,
    required this.gradeToDate,
  });

  double calculateAverage() {
    double totalWeightedGrade = 0;
    double totalWeightage = 0;
    for (var assessment in assessments) {
      totalWeightedGrade += (assessment.grade * assessment.weightage);
      totalWeightage += assessment.weightage;
    }
    return totalWeightage > 0 ? totalWeightedGrade / totalWeightage : 0;
  }

  void updateCourseTotalGrade() {
    double totalWeightage = 0;
    double totalMarks = 0;

    for (var i = 0; i < assessments.length; i++) {
      Assessment current = assessments.elementAt(i);
      if (current.grade != -1) {
        totalWeightage += current.weightage;
        totalMarks += (current.grade * current.weightage) / 100;
      }
    }
    totalGrade = totalMarks;
    if (totalWeightage != 0) {
      gradeToDate = totalMarks / totalWeightage * 100;
    } else {
      gradeToDate = 0;
    }
  }

  /// Calculate what grade is needed on remaining assessments to achieve target
  double whatIfAverageOnRemaining(double targetGrade, Course course) {
    double totalWeightage = 0;
    double totalMarks = 0;

    for (var i = 0; i < course.assessments.length; i++) {
      Assessment current = course.assessments.elementAt(i);
      if (current.grade != -1) {
        totalWeightage += current.weightage;
        totalMarks += current.grade * current.weightage / 100;
      }
    }

    double weightageRemaining = 100 - totalWeightage;
    double marksToGoal = targetGrade - totalMarks;
    return (marksToGoal / weightageRemaining) * 100;
  }

  /// Calculate final grade if a certain average is achieved on remaining assessments
  double whatIfOverallOnAverage(double averageOnRemaining, Course course) {
    double totalWeightage = 0;
    double totalMarks = 0;

    for (var i = 0; i < course.assessments.length; i++) {
      Assessment current = course.assessments.elementAt(i);
      if (current.grade != -1) {
        totalWeightage += current.weightage;
        totalMarks += current.grade * current.weightage / 100;
      }
    }

    double weightageRemaining = 100 - totalWeightage;
    totalMarks = totalMarks + (weightageRemaining * averageOnRemaining / 100);
    return totalMarks;
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    var assessmentsList = json['assessments'] as List;
    List<Assessment> assessmentsObjects =
        assessmentsList.map((i) => Assessment.fromJson(i)).toList();

    return Course(
      name: json['name'],
      code: json['code'],
      semesterId: json['semesterId'],
      weightage: json['weightage'],
      assessments: assessmentsObjects,
      totalGrade: json['totalGrade'],
      gradeToDate: json['gradeToDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'semesterId': semesterId,
        'weightage': weightage,
        'assessments': assessments.map((i) => i.toJson()).toList(),
        'totalGrade': totalGrade,
        'gradeToDate': gradeToDate,
      };
}
