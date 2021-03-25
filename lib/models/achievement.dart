class Achievement {
  String AchivmentId;
  String Title;
  String Category;
  String Remark;
  String ImageUrl;
  String AddedOn;

  Achievement({
    this.AchivmentId,
    this.Title,
    this.Category,
    this.Remark,
    this.ImageUrl,
    this.AddedOn,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      AchivmentId: json['AchivmentId'],
      Title: json['Title'],
      Category: json['Category'],
      Remark: json['Remark'],
      ImageUrl: json['ImageUrl'],
      AddedOn: json['AddedOn'],
    );
  }
}
