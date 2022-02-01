import 'package:flutter/material.dart';
import 'package:smart_shopping/pages/add_or_edit_recipe.dart';
import 'package:smart_shopping/pages/add_or_edit_shoping_list.dart';
import 'package:smart_shopping/services/database.dart';
import 'package:smart_shopping/services/shopping_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ShoppingLists _shoppingLists;

  Future<List<ShoppingList>> _loadShoppingLists() async {
    await DatabaseFileRoutines(database: "shopping_lists")
        .readDatabase()
        .then((json) {
      _shoppingLists = databaseFromJson(json);
    });

    return _shoppingLists.shoppingLists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Smart Shopping'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddOrEditShoppingList()));
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          initialData: const [],
          future: _loadShoppingLists(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            List<dynamic> shoppingLists = snapshot.data;
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: shoppingLists.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(shoppingLists[index].title),
                            leading: Text(
                              shoppingLists[index].ingredientList.length,
                              style: const TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
          },
        ));
  }
}
