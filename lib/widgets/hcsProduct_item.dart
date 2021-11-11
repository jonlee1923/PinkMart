import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/hcsProduct.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/providers/favorites.dart';
import '../screens/supermarketListingsSearchResults_screen.dart';
import '../screens/recipeSearchResults_screen.dart';

// Class to handle the UI subcomponent for a particular HCS product

class HcsProductItem extends StatefulWidget {
  final HcsProduct prod;
  String url;
  bool fav;

  HcsProductItem(this.prod, this.url);

  static String checkKeywords(String query) {
    List<String> keywords = [
      'fish',
      'chicken',
      'eggs',
      'milk',
      'pork',
      'butter',
      'sugar',
      'salt',
      'ginger',
      'vinegar',
      'sugar',
      'beef',
      'lamb',
      'fish',
      'chicken',
      'salt',
      'sugar',
      'butter',
      'eggs',
      'garlic',
      'water',
      'olive oil',
      'milk',
      'flour',
      'onion',
      'pepper',
      'onions',
      'black pepper',
      'brown sugar',
      'egg',
      'cinnamon',
      'all-purpose flour',
      'baking powder',
      'lemon juice',
      'tomatoes',
      'vanilla',
      'vanilla extract',
      'parsley',
      'unsalted butter',
      'baking soda',
      'sour cream',
      'vegetable oil',
      'celery',
      'ginger',
      'lemon',
      'cream cheese',
      'carrots',
      'cheddar cheese',
      'beef',
      'potatoes',
      'oil',
      'honey',
      'nutmeg',
      'cheese',
      'soy sauce',
      'mayonnaise',
      'chicken broth',
      'oregano',
      'cumin',
      'thyme',
      'garlic',
      'pepper',
      'mushrooms',
      'cilantro',
      'basil',
      'pecans',
      'bacon',
      'heavy cream',
      'chicken breasts',
      'worcestershire sauce',
      'paprika',
      'chocolate',
      'chicken',
      'walnuts',
      'chilli',
      'almonds',
      'juice',
      'parmesan cheese',
      'pineapple',
      'rice',
      'orange juice',
      'white sugar',
      'green pepper',
      'raisins',
      'coconut',
      'nuts',
      'dijon mustard',
      'cornstarch',
      'mozarella cheese',
      'buttermilk',
      'vinegar',
      'apples',
      'red pepper',
      'tomato sauce',
      'bread crumbs',
      'oats',
      'spinach',
      'shallots',
      'tomato paste',
      'red bell pepper',
      'lime',
      'shrimp',
      'zucchini',
      'strawberries',
      'rosemary',
      'canola oil',
      'green onions',
      'bananas',
      'scallions',
      'cloves',
      'mustard',
      'cocoa powder',
      'chicken stock',
      'sea salt',
      'chives',
      'whipping cream',
      'bread',
      'maple syrup',
      'orange',
      'corn starch',
      'balsamic vinegar',
      'dry white wine',
      'coriander',
      'bay leaf',
      'ketchup',
      'yogurt',
      'red wine vinegar',
      'avocado',
      'sesame oil',
      'cabbage',
      'bay leaves',
      'chocolate chips',
      'broccoli',
      'salt and black pepper',
      'chicken breast',
      'cocoa',
      'carrot',
      'basil leaves',
      'onion powder',
      'cucumber',
      'peanut butter',
      'allspice',
      'dry mustard',
      'cranberries',
      'mint',
      'ham',
      'green bell pepper',
      'blueberries',
      'soda',
      'wheat flour',
      'peas',
      'curry powder',
      'corn',
      'coconut milk',
      'lettuce',
      'sesame seeds',
      'pork',
      'turmeric',
      'pasta',
      'dill',
      'yellow onion',
      'white wine',
      'red onion',
      'jalapeno chilies',
      'cream of mushroom soup',
      'beans',
      'almond extract',
      'black beans',
      'garlic salt',
      'peanuts',
      'cider vinegar',
      'white vinegar',
      'margarine',
      'green beans',
      'cream',
      'molasses',
      'confectioners sugar',
      'pumpkin',
      'coconut oil',
      'sauce',
      'turkey',
      'yeast',
      'olives',
      'corn syrup',
      'sage',
      'rice vinegar',
      'raspberries',
      'beef broth',
      'salt & pepper',
      'ricotta cheese',
      'salsa',
      'tomato',
      'breadcrumbs',
      'spray',
      'cilantro leaves',
      'parsley leaves',
      'apple cider vinegar',
      'capers',
      'bell pepper',
      'gelatin',
      'green chilies',
      'black olives',
      'feta cheese',
      'swiss cheese',
      'cherry tomatoes',
      'potato',
      'oranges',
      'cool whip',
      'cream of tartar',
      'cornmeal',
      'pineapple juice',
      'italian seasoning',
      'salmon',
      'cooking oil',
    ];

    var words = query.split(' ');
    print(words);
    for (int i = 0; i < keywords.length; i++) {
      for (int j = 0; j < words.length; j++) {
        if (words[j].toLowerCase().contains(keywords[i])) {
          print(words[j]);
          print(keywords[i]);
          return keywords[i];
        }
      }
    }
    print('failed');
    return query;
  }

  @override
  _HcsProductItemState createState() => _HcsProductItemState();
}

class _HcsProductItemState extends State<HcsProductItem> {

  @override
  Widget build(BuildContext context) {
    bool isFavorite = widget.prod.isFavorite;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.deepOrange,
      elevation: 1,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 130,
            child: Container(
              child: widget.url != ""
                  ? Image.network(
                      widget.url,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Text('No image available');
                      },
                    )
                  : Text("Image unavailable"),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 170,
                child: Expanded(
                  child: Text(
                    widget.prod.productName,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text.rich(
                TextSpan(
                  text: widget.prod.packageSize,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
                ),
              )
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    bool authorised =
                        Provider.of<Auth>(context, listen: false).isAuth;
                    authorised
                        ? setState(() {
                            isFavorite = widget.prod.toggleFavoriteStatus();

                            isFavorite
                                ? Provider.of<Favorites>(context, listen: false)
                                    .addProduct(widget.prod, widget.url)
                                : Provider.of<Favorites>(context, listen: false)
                                    .deleteProduct(widget.prod.productName);

                            bool message =
                                Provider.of<Favorites>(context, listen: false)
                                    .checker;

                            

                            if (!message) {
                              isFavorite = widget.prod.toggleFavoriteStatus();

                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  //a snackbar is just a material design object which is shown at the bottom of the screen
                                  content: Text(
                                    'This product has already been added!',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              message = true;
                            }

                            // if (deleted) {
                            //   Scaffold.of(context).showSnackBar(
                            //     SnackBar(
                            //       //a snackbar is just a material design object which is shown at the bottom of the screen
                            //       content: Text(
                            //         'The product has been deleted!',
                            //       ),
                            //       duration: Duration(seconds: 2),
                            //     ),
                            //   );

                            //   deleted = false;
                            // }
                          })
                        : Scaffold.of(context).showSnackBar(
                            SnackBar(
                              //a snackbar is just a material design object which is shown at the bottom of the screen
                              content: Text(
                                'Please log in first!',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        SupermarketListingSearchResultsScreen.routeName,
                        arguments: widget.prod.productName);
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    String query =
                        HcsProductItem.checkKeywords(widget.prod.productName);
                    Navigator.of(context).pushNamed(
                        RecipeSearchResultsScreen.routeName,
                        arguments: query);
                  },
                  icon: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
