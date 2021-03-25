class MarriedTypeList {
  String MarriedType;

  MarriedTypeList({
    this.MarriedType,
  });

  factory MarriedTypeList.fromJson(Map<String, dynamic> json) {
    return MarriedTypeList(
      MarriedType: json['MarriedType'],
    );
  }
}