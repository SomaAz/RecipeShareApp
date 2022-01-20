class CategoryModel {
  final String name;
  final String image;
  final int recipesNumber;

  CategoryModel({
    required this.name,
    required this.image,
    required this.recipesNumber,
  });
  CategoryModel.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        image = data['image'],
        recipesNumber = data['recipesNumber'];
}
