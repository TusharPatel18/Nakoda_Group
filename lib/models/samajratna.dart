class SamajRatna {
  String SamajId;
  String Name;
  String ImageUrl;
  String Achivment;
  String Story;

  SamajRatna({
    this.SamajId,
    this.Name,
    this.ImageUrl,
    this.Achivment,
    this.Story,
  });

  factory SamajRatna.fromJson(Map<String, dynamic> json) {
    return SamajRatna(
      SamajId: json['SamajId'],
      Name: json['Name'],
      ImageUrl: json['ImageUrl'],
      Achivment: json['Achivment'],
      Story: json['Story'],
    );
  }
}
