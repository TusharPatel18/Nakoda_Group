class RelationTypeList {
  String RelationName;

  RelationTypeList({
    this.RelationName,
  });

  factory RelationTypeList.fromJson(Map<String, dynamic> json) {
    return RelationTypeList(
      RelationName: json['RelationName'],
    );
  }
}
