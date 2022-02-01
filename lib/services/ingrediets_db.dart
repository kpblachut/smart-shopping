import 'dart:convert';
import 'dart:math';

Ingredients databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Ingredients.fromJson(dataFromJson);
}

String databaseToJson(Ingredients data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

class Ingredients {
  List<Ingredient> ingredients;

  Ingredients({
    required this.ingredients,
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) => Ingredients(
        ingredients: List<Ingredient>.from(
            json["ingredients"].map((x) => Ingredient.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
      };
}

class Ingredient {
  final int id = Random().nextInt(100000);
  final String name;
  final String category;

  Ingredient({required this.name, required this.category});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(name: json['name'], category: json['category']);
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "category": category};
}

class IngredientEdit {
  String action;
  Ingredient ingredient;

  IngredientEdit({required this.action, required this.ingredient});
}
