import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/favorites.dart';
import 'package:flutter_complete_guide/screens/shoppingList_screen.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/favorites_screen.dart';
import 'package:flutter_complete_guide/services/hcsImagesApiManager.dart';
import 'package:flutter_complete_guide/widgets/hcsProduct_item.dart';
import 'package:flutter_complete_guide/widgets/home_product.dart';
import 'package:provider/provider.dart';
import '../models/hcsProduct.dart';
import '../models/images.dart';
import '../services/dataGovApiManager.dart';

// Classes to handle the UI for the favorites list screen.
class HcsProductsSearchResultsScreen extends StatefulWidget {
  static const routeName = '/hcsproducts-screen';

  @override
  _HcsProductsSearchResultsScreenState createState() =>
      _HcsProductsSearchResultsScreenState();
}

class _HcsProductsSearchResultsScreenState
    extends State<HcsProductsSearchResultsScreen> {
  List<HcsProduct> _listings;
  List<Images> _images;

  bool _loading = true;
  bool _home = true;
  bool _isInit = true;

  Icon cusIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  Widget cusSearchBar = Text("Pink Mart");

  get favorites => null;

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pushNamed(HcsProductsSearchResultsScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    }
  }

  List<Widget> _buildActions() => <Widget>[
        IconButton(
          icon: cusIcon,
          onPressed: () {
            setState(() {
              if (this.cusIcon.icon == Icons.search) {
                this.cusIcon = Icon(
                  Icons.cancel,
                  color: Colors.white,
                );
                this.cusSearchBar = TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (String value) async {
                    setState(() {
                      _loading = true;
                      _home = false;
                    });
                    _listings = await DataGovAPIManager.getProducts(value);
                    _images = await HcsImagesApiManager.getImages(value);
                    setState(() {
                      _loading = false;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Term",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                );
              } else {
                this.cusIcon = Icon(
                  Icons.search,
                  color: Colors.white,
                );
                this.cusSearchBar = Text("Pink Mart");

              }
            });
          },
          color: Colors.white,
          tooltip: 'Search',
        ),

        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            // Navigator.of(context).pushNamed(FavoritesScreen.routeName, arguments:favorites);
            Navigator.of(context)
                .pushNamed(FavoritesScreen.routeName, arguments: favorites)
                .then((_) {
              setState(() {
                _listings = null;
                _loading = true;
                // cusIcon = Icon(Icons.search);
              });
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(ShoppingListScreen.routeName);
          },
          // color: Colors.grey,
          tooltip: 'Cart',
        )
      ];

  @override
  void initState() {
    _home = true;
    super.initState();

  }

  @override
  void didChangeDependencies() {
    final query = ModalRoute.of(context).settings.arguments as String;

    if (query != null) {
      setState(() {
        _home = false;
        _loading = true;
      });
      DataGovAPIManager.getProducts(query).then((products) {
        HcsImagesApiManager.getImages(query).then((images) {
          setState(() {
            _home = false;
            _images = images;
            _listings = products;
            _loading = false;
          });
        });
      });


    }

    if (_isInit && Provider.of<Auth>(context).isAuth) {
      Provider.of<Favorites>(context).fetchAndSetFavs().then((_) {
        setState(() {
          _isInit = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: cusSearchBar,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,

        actions: _buildActions(),
      ),
      body: _loading
          ? _home
              ? HomeProduct()
              : Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
          : _listings == null
              ? AlertDialog(
                  title: Text(
                    "Alert!!",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  content: Text(
                    'Your search was invalid please enter a valid search.',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            HcsProductsSearchResultsScreen.routeName);
                      },
                    ),
                  ],
                )
              : _listings.isEmpty == false
                  ? ListView.builder(
                      itemCount: _listings == null
                          ? 0
                          : _listings.length < 10
                              ? _listings.length
                              : 10,
                      itemBuilder: (context, index) {
                        // SupermarketListings listing = _listings[index];

                        String url = _images[index].image;
                        HcsProduct listing = _listings[index];
                        return HcsProductItem(listing, url);
                      },
                    )
                  : AlertDialog(
                  title: Text(
                    "Alert!!",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  content: Text(
                    'No results found.',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            HcsProductsSearchResultsScreen.routeName);
                      },
                    ),
                  ],
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
              label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
