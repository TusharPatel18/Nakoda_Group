class News {
  String NewsId;
  String Title;
  String Remark;
  String ImageUrl;
  String Type;
  String AddedOn;

  News({
    this.NewsId,
    this.Title,
    this.Remark,
    this.ImageUrl,
    this.Type,
    this.AddedOn,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      NewsId: json['NewsId'],
      Title: json['Title'],
      Remark: json['Remark'],
      ImageUrl: json['ImageUrl'],
      Type: json['Type'],
      AddedOn: json['AddedOn'],
    );
  }
}
