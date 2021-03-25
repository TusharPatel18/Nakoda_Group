class NativePlaceList {
  String NativeId;
  String NativeName;

  NativePlaceList({
    this.NativeId,
    this.NativeName,

  });

  factory NativePlaceList.fromJson(Map<String, dynamic> json) {
    return NativePlaceList(
      NativeId: json['NativeId'],
      NativeName: json['NativeName'],
    );
  }
}