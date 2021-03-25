class PhotoList {
  String GalleryId;
  String ImageUrl;
  String IsActive;
  String Title;

  PhotoList({
    this.GalleryId,
    this.ImageUrl,
    this.IsActive,
    this.Title,
  });

  factory PhotoList.fromJson(Map<String, dynamic> json) {
    return PhotoList(
      GalleryId: json['GalleryId'],
      ImageUrl: json['ImageUrl'],
      IsActive: json['IsActive'],
      Title: json['Title'],
    );
  }
}
