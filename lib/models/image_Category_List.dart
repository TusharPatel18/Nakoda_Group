class ImageTypeList {
  String ImageName;

  ImageTypeList({
    this.ImageName,
  });

  factory ImageTypeList.fromJson(Map<String, dynamic> json) {
    return ImageTypeList(
      ImageName: json['ImageName'],
    );
  }
}
