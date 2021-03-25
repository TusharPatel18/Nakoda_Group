class Birthday {
  String FirstName;
  String MiddleName;
  String LastGautra;
  String Mobile1;
  String Photo;

  Birthday({
    this.FirstName,
    this.MiddleName,
    this.LastGautra,
    this.Mobile1,
    this.Photo,
  });

  factory Birthday.fromJson(Map<String, dynamic> json) {
    return Birthday(
      FirstName: json['FirstName'],
      MiddleName: json['MiddleName'],
      LastGautra: json['LastGautra'],
      Mobile1: json['Mobile1'],
      Photo: json['Photo'],
    );
  }
}
