class SponserList {
  String SponserId;
  String SponserName;
  String ImageUrl;
  String ContactNo;
  String WebLink;

  SponserList({
    this.SponserId,
    this.SponserName,
    this.ImageUrl,
    this.ContactNo,
    this.WebLink,
  });

  factory SponserList.fromJson(Map<String, dynamic> json) {
    return SponserList(
      SponserId: json['SponserId'],
      SponserName: json['SponserName'],
      ImageUrl: json['ImageUrl'],
      ContactNo: json['ContactNo'],
        WebLink: json['WebLink'],
    );
  }
}