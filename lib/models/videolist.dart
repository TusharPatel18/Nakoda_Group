class VideoList {
  String VideoId;
  String VideoUrl;

  VideoList({
    this.VideoId,
    this.VideoUrl,
  });

  factory VideoList.fromJson(Map<String, dynamic> json) {
    return VideoList(
      VideoId: json['VideoId'],
      VideoUrl: json['VideoUrl'],
    );
  }
}
