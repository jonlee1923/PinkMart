import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/ingredient_item.dart';
import 'auth_screen.dart';
import 'hcsProductsSearchResults_screen.dart';

// Class to handle the UI of the log in screen.

class DetailedRecipeScreen extends StatefulWidget {
  static const routeName = '/recipe-details';

  @override
  _DetailedRecipeScreenState createState() => _DetailedRecipeScreenState();
}

class _DetailedRecipeScreenState extends State<DetailedRecipeScreen> {
  Widget cusSearchBar = Text("Recipe Details");
  List<dynamic> _ingredients;
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
    _ingredients = ModalRoute.of(context).settings.arguments as List<dynamic>;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: cusSearchBar,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _ingredients.length,
        itemBuilder: (context, index) {
          dynamic ingredient = _ingredients[index];
          return IngredientItem(ingredient);
        },
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
