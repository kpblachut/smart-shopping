import 'dart:convert';
import 'dart:math';

import 'package:smart_shopping/services/ingrediets_db.dart';

ShoppingLists databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return ShoppingLists.fromJson(dataFromJson);
}

String databaseToJson(ShoppingLists data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

class ShoppingLists {
  List<ShoppingList> shoppingLists;

  ShoppingLists({
    required this.shoppingLists,
  });

  factory ShoppingLists.fromJson(Map<String, dynamic> json) => ShoppingLists(
        shoppingLists: List<ShoppingList>.from(
            json["shopping_lists"].map((x) => ShoppingList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shopping_lists":
            List<dynamic>.from(shoppingLists.map((x) => x.toJson())),
      };
}

class ShoppingList {
  final int id;
  final String title;
  final List<IngredientItem> ingredientItems;

  ShoppingList(
      {required this.id, required this.title, required this.ingredientItems});

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
        id: json['id'],
        title: json['title'],
        ingredientItems: List<IngredientItem>.from(
            json["ingredientItems"].map((x) => IngredientItem.fromJson(x))));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "ingredientItems":
            List<dynamic>.from(ingredientItems.map((x) => x.toJson()))
      };
}

class IngredientItem {
  final Ingredient ingredient;
  final bool status;

  IngredientItem({required this.ingredient, required this.status});

  factory IngredientItem.fromJson(Map<String, dynamic> json) => IngredientItem(
      ingredient: Ingredient.fromJson(json['ingredient']),
      status: json['status']);

  Map<String, dynamic> toJson() =>
      {"ingrediet": ingredient.toJson(), "status": status};
}

class ShopingListEdit {
  String action;
  ShoppingList shoppingList;

  ShopingListEdit({required this.action, required this.shoppingList});
}
