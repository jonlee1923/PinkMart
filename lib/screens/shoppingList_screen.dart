import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/supermarketListings_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/models/supermarket_listing.dart';
import '../providers/auth.dart';
import '../providers/shoppingList.dart';
import 'auth_screen.dart';
import 'hcsProductsSearchResults_screen.dart';


// Class to handle the UI for the recipe search results screen.
class ShoppingListScreen extends StatefulWidget {
  static const routeName = '/shoppingList-screen';

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  bool _isInit = true;

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
    if (_isInit) {
      try {
        Provider.of<ShoppingList>(context).fetchAndSetCart().then((_) {
          setState(() {
            _isInit = false;
          });
        });
      } catch (error) {
        AlertDialog(
          title: Text(
            "Alert!!",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: Text(
            'Sorry, the Shopping List is currently unavailable. Please try again later.',
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<SupermarketListing> _cart =
        Provider.of<ShoppingList>(context, listen: false).items;
    bool authorised = Provider.of<Auth>(context, listen: false).isAuth;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        // actions: _buildActions(),
      ),
      body: authorised
          ? _cart.isEmpty
              ? AlertDialog(
                  title: Text(
                    "Alert!!",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  content: Text(
                    'Shopping list is empty!',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: _cart == null ? 0 : _cart.length,
                  itemBuilder: (context, index) {
                    SupermarketListing listing = _cart[index];
                    return SupermarketItem(listing, true);
                    // return ShoppingListItem(index.toString(), listing.imageurl,
                    //     listing.price, listing.product, listing.redirectUrl);
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
                'Please log in first!',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
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
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
