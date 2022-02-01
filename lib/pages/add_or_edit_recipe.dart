import 'package:flutter/material.dart';
import 'package:smart_shopping/pages/add_ingredient.dart';

class AddOrEditRecipe extends StatefulWidget {
  @override
  State<AddOrEditRecipe> createState() => _AddOrEditRecipeState();
}

class _AddOrEditRecipeState extends State<AddOrEditRecipe> {
  late String _ingredientsText;
  late List<String> _ingredients;

  @override
  void initState() {
    super.initState();

    _ingredientsText = "";
    _ingredients = [];
  }

  void updateIngredientsListString() {
    String _newIngredientsText = "";
    _ingredients.forEach((element) {
      _newIngredientsText += "- $element \n";
    });

    setState(() {
      _ingredientsText = _newIngredientsText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add recipe'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const TextField(),
            const TextField(),
            ElevatedButton(
              child: const Text('Add ingredient'),
              onPressed: () async {
                String newIngredient = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddIngridient(
                              ingredientsList: _ingredients,
                            )));
                if (newIngredient.isNotEmpty) {
                  _ingredients.add(newIngredient);
                  updateIngredientsListString();
                }
              },
            ),
            Text(
              "$_ingredientsText",
            )
          ],
        ),
      ),
    );
  }
}
