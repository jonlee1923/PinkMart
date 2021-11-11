// import 'dart:html';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/hcsProduct.dart';
import '../providers/favorites.dart';
import '../widgets/hcsProduct_item.dart';
import '../providers/auth.dart';
import 'auth_screen.dart';
import 'hcsProductsSearchResults_screen.dart';


// Classes to handle the UI for the detailed recipe's screen.

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites-screen';

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var _isInit = true;
  var _isLoading = true;
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
    //this will run after the widget has been fully initialised but before build is run for the first time
    if (_isInit) {


      try {
        Provider.of<Favorites>(context).fetchAndSetFavs().then((_) {
          setState(() {
            _isLoading = false;
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
            'Sorry, the Favorites List is currently unavailable. Please try again later.',
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
    List<HcsProduct> favorites = Provider.of<Favorites>(context).items;
    bool authorised = Provider.of<Auth>(context, listen: false).isAuth;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Favorites Screen'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: authorised
          ? _isLoading
              ? Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
              : favorites.isEmpty
                  ? AlertDialog(
                      title: Text(
                        "Alert!!",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      content: Text(
                        'You have no favorites yet - start adding some!',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("OK"),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(
                                HcsProductsSearchResultsScreen.routeName);
                          },
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return HcsProductItem(
                            favorites[index], favorites[index].imageUrl);
                      },
                      itemCount: favorites.length,
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
