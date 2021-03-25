class AudioList {
  String AudioId;
  String Title;
  String AudioUrl;

  AudioList({
    this.AudioId,
    this.Title,
    this.AudioUrl,
  });

  factory AudioList.fromJson(Map<String, dynamic> json) {
    return AudioList(
      AudioId: json['AudioId'],
      Title: json['Title'],
      AudioUrl: json['AudioUrl'],
    );
  }
}
