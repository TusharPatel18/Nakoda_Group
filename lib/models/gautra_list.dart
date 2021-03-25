class GautraList {
  String GautraName;

  GautraList({
    this.GautraName,
  });

  factory GautraList.fromJson(Map<String, dynamic> json) {
    return GautraList(
      GautraName: json['GautraName'],
    );
  }
}
