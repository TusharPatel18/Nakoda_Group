class Job {
  String JobId;
  String CompanyName;
  String EmailId;
  String Title;
  String ContactNumber;
  String Remark;

  Job({
    this.JobId,
    this.CompanyName,
    this.EmailId,
    this.Title,
    this.ContactNumber,
    this.Remark,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      JobId: json['JobId'],
      CompanyName: json['CompanyName'],
      EmailId: json['EmailId'],
      Title: json['Title'],
      ContactNumber: json['ContactNumber'],
      Remark: json['Remark'],
    );
  }
}
