import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_tracker_app/models/assessment.dart';
import 'package:grade_tracker_app/models/course.dart';
import 'package:grade_tracker_app/screens/course_graph_page.dart';

class CoursePageWidget extends StatefulWidget {
  final Course course;
  const CoursePageWidget({super.key, required this.course});

  @override
  State<CoursePageWidget> createState() => _CoursePageWidgetState();
}

class _CoursePageWidgetState extends State<CoursePageWidget> {
  double averageOnRemaining = 0;
  double overallOnAverage = 0;

  late Assessment newAssessment;
  bool isValidName = false;
  bool isValidWeight = false;

  final courseNameController = TextEditingController();
  final courseWeightController = TextEditingController();
  final courseGradeController = TextEditingController();
  final whatIfAverageController = TextEditingController();
  final whatIfOverallController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.course.updateCourseTotalGrade();

    whatIfAverageController.addListener(() {
      if (double.tryParse(whatIfAverageController.text) != null) {
        setState(() {
          averageOnRemaining = widget.course.whatIfAverageOnRemaining(
            double.parse(whatIfAverageController.text),
            widget.course,
          );
        });
      } else if (whatIfAverageController.text == "") {
        setState(() {
          averageOnRemaining = 0;
        });
      }
    });

    whatIfOverallController.addListener(() {
      if (double.tryParse(whatIfOverallController.text) != null) {
        setState(() {
          overallOnAverage = widget.course.whatIfOverallOnAverage(
            double.parse(whatIfOverallController.text),
            widget.course,
          );
        });
      } else if (whatIfOverallController.text == "") {
        setState(() {
          overallOnAverage = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    courseNameController.dispose();
    courseWeightController.dispose();
    courseGradeController.dispose();
    whatIfAverageController.dispose();
    whatIfOverallController.dispose();
    super.dispose();
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_outlined_outlined),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseGraphPageWidget(course: widget.course),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildGradeHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: widget.course.assessments.length + 2,
              itemBuilder: (context, index) {
                if (index < widget.course.assessments.length) {
                  return _buildAssessmentCard(index);
                } else if (index == widget.course.assessments.length) {
                  return _buildAddAssessmentCard();
                } else {
                  return _buildWhatIfSection();
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 5);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  " Grade: ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Text(
                  "${widget.course.gradeToDate.toStringAsFixed(2)} % ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.course.totalGrade.toStringAsFixed(2)} % ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const Text(
                  " of final grade",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(int index) {
    final assessment = widget.course.assessments[index];
    return Card(
      child: GestureDetector(
        onTap: () => _showEditAssessmentDialog(index),
        child: ListTile(
          title: Text(assessment.name),
          subtitle: Text("Weight: ${assessment.weightage.toStringAsFixed(2)}%"),
          trailing: (assessment.grade == -1)
              ? const Text(
                  "No Grade",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )
              : Text(
                  assessment.grade.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 24),
                ),
        ),
      ),
    );
  }

  void _showEditAssessmentDialog(int index) {
    final assessment = widget.course.assessments[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Assessment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextField(
                      controller: courseNameController,
                      onTap: () {
                        courseNameController.text = assessment.name;
                      },
                      decoration: InputDecoration(
                        labelText: "Assessment Name: ",
                        hintText: assessment.name.isEmpty
                            ? 'Assessment Name'
                            : assessment.name,
                      ),
                    ),
                    TextField(
                      controller: courseWeightController,
                      onTap: () {
                        courseWeightController.text =
                            assessment.weightage.toString();
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Assessment Weight: ",
                        hintText: assessment.weightage == -1
                            ? '00.00 %'
                            : assessment.weightage.toStringAsFixed(2),
                      ),
                    ),
                    TextField(
                      controller: courseGradeController,
                      onTap: () {
                        if (assessment.grade != -1) {
                          courseGradeController.text =
                              assessment.grade.toString();
                        }
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Grade (%): - optional",
                        hintText: assessment.grade == -1
                            ? 'No Grade'
                            : assessment.grade.toStringAsFixed(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _clearControllers();
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _clearControllers();
                              widget.course.assessments.removeAt(index);
                              widget.course.updateCourseTotalGrade();
                            });
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          if (courseNameController.text.isNotEmpty) {
                            assessment.name = courseNameController.text;
                          }
                          final weight =
                              double.tryParse(courseWeightController.text);
                          if (weight != null && weight >= 0 && weight <= 100) {
                            assessment.weightage = weight;
                          }
                          if (courseGradeController.text.isNotEmpty) {
                            assessment.grade =
                                double.parse(courseGradeController.text);
                          } else {
                            assessment.grade = -1;
                          }
                          _clearControllers();
                          widget.course.updateCourseTotalGrade();
                        });
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddAssessmentCard() {
    return Card(
      child: GestureDetector(
        onTap: () => _showAddAssessmentDialog(),
        child: const ListTile(
          leading: Icon(Icons.add),
          title: Text("Add Assessment"),
        ),
      ),
    );
  }

  void _showAddAssessmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "New Assessment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextField(
                      controller: courseNameController,
                      decoration: const InputDecoration(
                        labelText: "Assessment Name: ",
                        hintText: 'Assessment Name',
                      ),
                    ),
                    TextField(
                      controller: courseWeightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Assessment Weight: ",
                        hintText: '00.00 %',
                      ),
                    ),
                    TextField(
                      controller: courseGradeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Grade (%): - optional",
                        hintText: 'No Grade',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _clearControllers();
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _addNewAssessment();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addNewAssessment() {
    setState(() {
      newAssessment = Assessment(
        name: "placeholder",
        weightage: -1,
        grade: -1,
      );

      if (courseNameController.text.isNotEmpty) {
        newAssessment.name = courseNameController.text;
        isValidName = true;
      }

      final weight = double.tryParse(courseWeightController.text);
      if (weight != null && weight >= 0 && weight <= 100) {
        newAssessment.weightage = weight;
        isValidWeight = true;
      }

      if (courseGradeController.text.isNotEmpty) {
        newAssessment.grade = double.parse(courseGradeController.text);
      } else {
        newAssessment.grade = -1;
      }

      _clearControllers();

      if (isValidName && isValidWeight) {
        widget.course.assessments.add(newAssessment);
      } else if (!isValidName) {
        _showValidationError("Please enter a valid name for the assessment");
      } else if (!isValidWeight) {
        _showValidationError("Please enter a valid weight for the assessment");
      }

      isValidName = false;
      isValidWeight = false;
      widget.course.updateCourseTotalGrade();
    });
  }

  void _clearControllers() {
    courseNameController.clear();
    courseWeightController.clear();
    courseGradeController.clear();
  }

  Widget _buildWhatIfSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 8),
          child: Divider(),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "What Do I Need?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 14, bottom: 8),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Average on remaining to get ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                WidgetSpan(
                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: whatIfAverageController,
                      inputFormatters: [LengthLimitingTextInputFormatter(3)],
                    ),
                  ),
                ),
                const TextSpan(
                  text: " % overall.",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 14),
          child: Text(
            "Need: ${averageOnRemaining.toStringAsFixed(2)} %",
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 14, bottom: 8),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Overall grade if I get ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                WidgetSpan(
                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: whatIfOverallController,
                      inputFormatters: [LengthLimitingTextInputFormatter(3)],
                    ),
                  ),
                ),
                const TextSpan(
                  text: " % on remaining.",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 14),
          child: Text(
            "Need: ${overallOnAverage.toStringAsFixed(2)} %",
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
