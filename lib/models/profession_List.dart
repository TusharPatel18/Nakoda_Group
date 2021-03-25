class ProfessionList {
  String ProfessionId;
  String ProfessionName;

  ProfessionList({
    this.ProfessionId,
    this.ProfessionName,

  });

  factory ProfessionList.fromJson(Map<String, dynamic> json) {
    return ProfessionList(
      ProfessionId: json['ProfessionId'],
      ProfessionName: json['ProfessionName'],
    );
  }
}