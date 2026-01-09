class Assessment {
  late String name;
  late double weightage;
  late double grade;

  Assessment({
    required this.name,
    required this.weightage,
    required this.grade,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      name: json['name'],
      weightage: json['weightage'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'weightage' : weightage,
    'grade' : grade,
  };
}


