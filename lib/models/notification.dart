class Notifications {
  String NotificationId;
  String Title;
  String Message;
  String AddedOn;
  String ImageUrl;

  Notifications({
    this.NotificationId,
    this.Title,
    this.Message,
    this.AddedOn,
    this.ImageUrl,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      NotificationId: json['NotificationId'],
      Title: json['Title'],
      Message: json['Message'],
      AddedOn: json['AddedOn'],
      ImageUrl: json['ImageUrl'],
    );
  }
}
