class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int recipesNumber;

  CategoryModel({
    required this.name,
    required this.image,
    required this.recipesNumber,
    required this.id,
  });
  CategoryModel.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        image = data['image'],
        id = data['id'],
        recipesNumber = data['recipesNumber'];
}
