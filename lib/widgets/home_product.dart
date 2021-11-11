import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import '../models/hcsProduct.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/providers/favorites.dart';
import '../screens/supermarketListingsSearchResults_screen.dart';
import '../screens/recipeSearchResults_screen.dart';

// Class to populate the HCS products search results screen(Home screen) with the most popular HCS products
List<HcsProduct> _home = [
  HcsProduct(productName: 'Milo 450g', packageSize: '450G'),
  HcsProduct(
      productName: 'Chew\'s Organic Selenium Fresh Eggs', packageSize: '550g'),
  HcsProduct(productName: 'Fresh Rice Organic Mixed Rice', packageSize: '2kg'),
  HcsProduct(
      productName: 'Marigold Low Fat Milk - UHT Recombined Low Fat Milk',
      packageSize: '1L'),
  HcsProduct(productName: 'Golden Leaf Brown Rice Noodle', packageSize: '400g'),
  HcsProduct(
      productName:
          'Fairprice Sunflower with Extra Virgin Olive Oil & Mixed Seeds Oil',
      packageSize: '500ml'),
];

class HomeProduct extends StatefulWidget {
  bool fav;

  List<String> _url = [
    'https://coldstorage-s3.dexecure.net/product_thumb/1194507_1528887645696.jpg',
    'https://coldstorage-s3.dexecure.net/product/3068167_1528883742465.jpg',
    'https://coldstorage-s3.dexecure.net/product/Organic%20Brown%20Rice%202kg.jpg',
    'https://coldstorage-s3.dexecure.net/product_thumb/760016_1528883979735.jpg',
    'https://laz-img-sg.alicdn.com/p/330659b0f1bbee61eb2bca16755b803c.jpg',
    'https://coldstorage-s3.dexecure.net/product_thumb/Extra%20Virgin%20Olive%20Oil%201.5L.jpg'
  ];

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
      'MILO',
      'milo',
      'rice',
      'noodles',
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
  _HomeProductState createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  bool message;
  @override
  Widget build(BuildContext context) {
    // bool isFavorite = widget.prod.isFavorite;
    return ListView.builder(
      itemCount: _home.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Theme.of(context).primaryColor,
          elevation: 2,
          child: Row(
            children: [
              SizedBox(
                  width: 100,
                  height: 130,
                  child: Container(
                    child: Image.network(widget._url[index]),
                  )),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 170,
                    child: Expanded(
                      child: Text(
                        _home[index].productName,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        // maxLines: 2,
                        // overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      text: _home[index].packageSize,
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
                        _home[index].isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      color: Colors.red,
                      onPressed: () {
                        bool authorised =
                            Provider.of<Auth>(context, listen: false).isAuth;

                        authorised
                            ? setState(() {
                                _home[index].isFavorite =
                                    _home[index].toggleFavoriteStatus();

                                _home[index].isFavorite
                                    ? Provider.of<Favorites>(context,
                                            listen: false)
                                        .addProduct(
                                            _home[index], widget._url[index])
                                    : Provider.of<Favorites>(context,
                                            listen: false)
                                        .deleteProduct(
                                            _home[index].productName);
                                bool message = Provider.of<Favorites>(context,
                                        listen: false)
                                    .checker;

                                if (!message) {
                                  _home[index].isFavorite =
                                      _home[index].toggleFavoriteStatus();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      //a snackbar is just a material design object which is shown at the bottom of the screen
                                      content: Text(
                                        'This product has already been added!',
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                  message = true;
                                }
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
                        //to favorite the item
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        print(_home[index].productName);
                        Navigator.of(context).pushNamed(
                            SupermarketListingSearchResultsScreen.routeName,
                            arguments: _home[index].productName);
                      },
                      icon: Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {
                        String query =
                            HomeProduct.checkKeywords(_home[index].productName);
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
      },
    );
  }
}
