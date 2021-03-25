class VideoTypeList {
  String VideoName;

  VideoTypeList({
    this.VideoName,
  });

  factory VideoTypeList.fromJson(Map<String, dynamic> json) {
    return VideoTypeList(
      VideoName: json['VideoName'],
    );
  }
}
