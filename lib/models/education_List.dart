class EducationList {
  String Education_id;
  String EducationName;

  EducationList({
    this.Education_id,
    this.EducationName,
  });

  factory EducationList.fromJson(Map<String, dynamic> json) {
    return EducationList(
      Education_id: json['Education_id'],
      EducationName: json['EducationName'],
    );
  }
}