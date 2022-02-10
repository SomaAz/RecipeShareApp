class IngredientModel {
  final String ingredient;
  final String quantity;

  IngredientModel({
    required this.ingredient,
    required this.quantity,
  });

  IngredientModel.fromString(String string)
      : ingredient = string.split(">")[0],
        quantity = string.split(">")[0];
}
