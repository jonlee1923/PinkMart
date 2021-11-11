import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/edamamApiManager.dart';
import 'package:flutter_complete_guide/widgets/recipe_item.dart';
import '../models/recipe.dart';
import 'auth_screen.dart';
import 'hcsProductsSearchResults_screen.dart';


// Class to handle the UI for the HCS products search results screen (Home screen).
class RecipeSearchResultsScreen extends StatefulWidget {
  static const routeName = '/recipes';

  @override
  _RecipeSearchResultsScreenState createState() =>
      _RecipeSearchResultsScreenState();
}

class _RecipeSearchResultsScreenState extends State<RecipeSearchResultsScreen> {
  List<Recipe> _recipes;
  bool _loading = true;
  // Icon cusIcon = Icon(Icons.search);
  // Widget cusSearchBar = Text("Recipes");

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pushNamed(HcsProductsSearchResultsScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    }
  }

  @override
  void didChangeDependencies() {
    final query = ModalRoute.of(context).settings.arguments as String;
    print(query);
    EdamamApiManager.getRecipes(query).then((recipes) {
      setState(() {
        _recipes = recipes;
        _loading = false;
      });
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Recipes"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,

      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : _recipes.isEmpty == false
              ? ListView.builder(
                  itemCount: _recipes == null ? 0 : _recipes.length,
                  itemBuilder: (context, index) {
                    Recipe recipe = _recipes[index];
                    return RecipeItem(recipe);
                  },
                )
              : Center(
                  child: Text("No results found."),
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
