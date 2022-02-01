import 'package:flutter/material.dart';
import 'package:smart_shopping/services/ingrediets_db.dart';
import 'package:smart_shopping/services/database.dart';

class AddIngridient extends StatefulWidget {
  final List<String> ingredientsList;
  const AddIngridient({Key? key, required this.ingredientsList})
      : super(key: key);

  @override
  State<AddIngridient> createState() => _AddIngridientState();
}

class _AddIngridientState extends State<AddIngridient> {
  late List<String> _ingredientsList;
  late Ingredients _ingredients;
  // List ingredients = ["tomato", "avocado", "salad", "olive oil"];
  // Controller for TextField() that inputs new ingredient
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _ingredientsList = widget.ingredientsList;
  }

  Future<List<Ingredient>> _loadIngredients() async {
    await DatabaseFileRoutines(database: "ingredients")
        .readDatabase()
        .then((json) {
      _ingredients = databaseFromJson(json);
    });

    return _ingredients.ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If user decides to go back a page without selecting anything
        // return "" to prevent returning null
        Navigator.pop(context, "");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add ingredient'),
        ),
        body: FutureBuilder(
          initialData: [],
          future: _loadIngredients(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildIngredientsListView(snapshot);
          },
        ),
      ),
    );
  }

  Widget _buildIngredientsListView(AsyncSnapshot snapshot) {
    List<dynamic> ingredients = snapshot.data;
    return SafeArea(
        child: SingleChildScrollView(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          // Gives ListView only as much space as it needs
          shrinkWrap: true,
          itemCount: ingredients.length + 1,
          itemBuilder: (BuildContext context, int index) =>
              _buildListViewWithTextField(context, index, ingredients)),
    ));
  }

  // Builds ListView with TextField as a first index
  Widget _buildListViewWithTextField(
      BuildContext context, int index, List<dynamic> ingredients) {
    return index == 0
        ? TextField(
            // This is used to update controller
            onChanged: (value) {
              setState(() {});
            },
            onSubmitted: (value) => addToIngredientsList(context),
            controller: _controller,
            // Creates button that appears when user starts typing
            decoration: InputDecoration(
                suffixIcon: _controller.text == ""
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          addToIngredientsList(context);
                        },
                      )),
          )
        : Dismissible(
            key: Key(ingredients[index - 1].id.toString()),
            onDismissed: (direction) {
              ingredients.removeAt(index - 1);
              DatabaseFileRoutines(database: "ingredients")
                  .writeDatabase(databaseToJson(_ingredients));
            },
            child: ListTile(
              title: Text(
                "${ingredients[index - 1].name}",
              ),
              onTap: () {
                if (!_ingredientsList.contains(ingredients[index - 1].name)) {
                  Navigator.pop(context, ingredients[index - 1].name);
                }
                // TODO: Create Snackbar informing about doubled choice
              },
            ),
          );
  }

  void addToIngredientsList(BuildContext context) {
    Ingredient newIngredient =
        Ingredient(name: _controller.text, category: 'test');

    _controller.clear();
    setState(() {
      _ingredients.ingredients.add(newIngredient);
    });
    DatabaseFileRoutines(database: "ingredients")
        .writeDatabase(databaseToJson(_ingredients));

    Navigator.pop(context, newIngredient.name);
  }
}
