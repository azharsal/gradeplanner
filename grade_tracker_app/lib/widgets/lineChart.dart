import 'package:flutter/material.dart';
import 'package:grade_tracker_app/models/assessment_grade.dart';
import 'package:grade_tracker_app/models/course.dart';
import 'package:fl_chart/fl_chart.dart';



class LineChartWidget extends StatelessWidget {
  final Course course;
  final List<AssessmentGrade> grades;

  const LineChartWidget(this.course, this.grades, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 0.75,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 20, top: 0, bottom: 0),
          child: LineChart(
            chartData(course, grades),
          ),
        ),
      ),
    );
  }
}



LineChartData chartData(Course course, List<AssessmentGrade> grades) {
  const List<Color> gradientColors = [
    Colors.teal,
    Color.fromARGB(255, 10, 211, 191),
  ];



  return LineChartData(
    gridData: const FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 10,
      verticalInterval: 1,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      minY: 0,
      maxY: 100,


    lineBarsData: [ 
      LineChartBarData(
        spots: grades.map((grade) => FlSpot(grade.index, grade.grade)).toList(),
        isCurved: true,
         gradient: const LinearGradient(
            colors: gradientColors,
        ),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
      ), 
    
    ],
    titlesData: const FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),  
    ),
  );
}



