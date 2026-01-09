
import 'package:grade_tracker_app/models/course.dart';
import 'package:collection/collection.dart';

class AssessmentGrade {
  final double index;
  final double grade;
  
  AssessmentGrade({required this.index, required this.grade});
}






List<AssessmentGrade> getGradeList(Course course) {
  final data = <double>[];
  // add all grades for assessments in data list
  for (int i = 0; i < course.assessments.length; i++ ) {
    if (course.assessments.elementAt(i).grade != -1){
      data.add(course.assessments.elementAt(i).grade);
    }
  }
  return data.mapIndexed(
    ((index, element) => AssessmentGrade(index: index.toDouble(), grade: element))
  ).toList();
}