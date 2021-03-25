class GenderTypeList {
  String GenderType;

  GenderTypeList({
    this.GenderType,
  });

  factory GenderTypeList.fromJson(Map<String, dynamic> json) {
    return GenderTypeList(
      GenderType: json['GenderType'],
    );
  }
}