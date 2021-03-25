class IncomeLevelTypeList {
  String TypeName;

  IncomeLevelTypeList({
    this.TypeName,
  });

  factory IncomeLevelTypeList.fromJson(Map<String, dynamic> json) {
    return IncomeLevelTypeList(
      TypeName: json['TypeName'],
    );
  }
}
