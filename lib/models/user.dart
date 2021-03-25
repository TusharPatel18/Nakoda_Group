class User {
  String MembershipId;
  String FirstName;
  String MiddleName;
  String LastGautra;
  String Mobile1;
  User(this.MembershipId, this.FirstName, this.MiddleName, this.LastGautra,
      this.Mobile1);

  User.map(dynamic obj) {
    this.MembershipId = obj["MembershipId"];
    this.FirstName = obj["FirstName"];
    this.MiddleName = obj["MiddleName"];
    this.LastGautra = obj["LastGautra"];
    this.Mobile1 = obj["Mobile1"];
  }

  String get username => FirstName + " " + MiddleName + " " + LastGautra;
  String get password => Mobile1;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["MembershipId"] = MembershipId;
    map["FirstName"] = FirstName;
    map["MiddleName"] = MiddleName;
    map["LastGautra"] = LastGautra;
    map["Mobile1"] = Mobile1;
    return map;
  }
}
