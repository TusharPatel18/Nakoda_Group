class SpecialTypeList {
  String SpecialName;

  SpecialTypeList({
    this.SpecialName,
  });

  factory SpecialTypeList.fromJson(Map<String, dynamic> json) {
    return SpecialTypeList(
      SpecialName: json['SpecialName'],
    );
  }
}
