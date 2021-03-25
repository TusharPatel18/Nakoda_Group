class CityList {
  String CityId;
  String CityName;

  CityList({
    this.CityId,
    this.CityName,
  });

  factory CityList.fromJson(Map<String, dynamic> json) {
    return CityList(
      CityId: json['CityId'],
      CityName: json['CityName'],
    );
  }
}
