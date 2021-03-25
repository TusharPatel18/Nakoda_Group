class MemberTypeList {
  String MemberType;

  MemberTypeList({
    this.MemberType,
  });

  factory MemberTypeList.fromJson(Map<String, dynamic> json) {
    return MemberTypeList(
      MemberType: json['MemberType'],
    );
  }
}