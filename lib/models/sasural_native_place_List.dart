class SasuralNativePlaceList {
  String SasuralNativeId;
  String SasuralNativeName;

  SasuralNativePlaceList({
    this.SasuralNativeId,
    this.SasuralNativeName,

  });

  factory SasuralNativePlaceList.fromJson(Map<String, dynamic> json) {
    return SasuralNativePlaceList(
      SasuralNativeId: json['NativeId'],
      SasuralNativeName: json['NativeName'],
    );
  }
}