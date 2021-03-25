class BloodGroupTypeList {
  String BloodGroupName;

  BloodGroupTypeList({
    this.BloodGroupName,
  });

  factory BloodGroupTypeList.fromJson(Map<String, dynamic> json) {
    return BloodGroupTypeList(
      BloodGroupName: json['BloodGroupName'],
    );
  }
}
