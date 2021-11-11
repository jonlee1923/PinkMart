import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/shoppingList_screen.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/favorites_screen.dart';
import 'package:provider/provider.dart';
import '../providers/favorites.dart';
import 'providers/shoppingList.dart';
import 'screens/hcsProductsSearchResults_screen.dart';
import 'screens/supermarketListingsSearchResults_screen.dart';
import 'screens/recipeSearchResults_screen.dart';
import 'screens/detailedRecipe_screen.dart';

//Class that defines the entry point (Home screen) for the app and declares the observers and listeners. The routes to each screen are also declared here.
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Favorites>(
          update: (ctx, auth, previousFavs) => Favorites(
            auth.token,
            auth.userId,
            previousFavs == null ? [] : previousFavs.items,
          ),
        ),

        ChangeNotifierProxyProvider<Auth, ShoppingList>(
          update: (ctx, auth, previousItems) => ShoppingList(
            auth.token,
            auth.userId,
            previousItems == null ? [] : previousItems.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
            theme: ThemeData(
              backgroundColor: Colors.white,
              primarySwatch: Colors.green,
              secondaryHeaderColor: Colors.red,
              canvasColor: Color.fromRGBO(11, 218, 81, 1),
            ),
            home: HcsProductsSearchResultsScreen(),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ShoppingListScreen.routeName: (ctx) => ShoppingListScreen(),
              FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
              HcsProductsSearchResultsScreen.routeName: (ctx) =>
                  HcsProductsSearchResultsScreen(),
              SupermarketListingSearchResultsScreen.routeName: (ctx) =>
                  SupermarketListingSearchResultsScreen(),
              RecipeSearchResultsScreen.routeName: (ctx) =>
                  RecipeSearchResultsScreen(),
              DetailedRecipeScreen.routeName: (ctx) => DetailedRecipeScreen(),
            }),
      ),
    );
  }
}
