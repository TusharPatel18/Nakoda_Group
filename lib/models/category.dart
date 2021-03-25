class CategoryList {
  String CategoryId;
  String CategoryName;
  String CategoryType;

  CategoryList({
    this.CategoryId,
    this.CategoryName,
    this.CategoryType,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      CategoryId: json['CategoryId'],
      CategoryName: json['CategoryName'],
      CategoryType: json['CategoryType'],
    );
  }
}