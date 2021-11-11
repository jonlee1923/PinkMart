import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/supermarket_listing.dart';
import 'package:flutter_complete_guide/screens/shoppingList_screen.dart';
import 'package:flutter_complete_guide/widgets/supermarketListings_item.dart';
import '../services/supermarketListingManager.dart';
import 'auth_screen.dart';
import 'hcsProductsSearchResults_screen.dart';

// Class to handle the UI for the Supermarket listings search results screen. 
class SupermarketListingSearchResultsScreen extends StatefulWidget {
  static const routeName = '/supermarket-listings';

  @override
  _SupermarketListingSearchResultsScreenState createState() =>
      _SupermarketListingSearchResultsScreenState();
}

class _SupermarketListingSearchResultsScreenState
    extends State<SupermarketListingSearchResultsScreen> {
  List<SupermarketListing> _listings;
  List<SupermarketListing> _sortedListings;
  bool _loading = true;
  // Icon cusIcon = Icon(Icons.search);

  List<String> dropDown = <String>[
    "Default",
    "By Name",
    "By Brand",
    "By Price",
  ];

  // switch for sorting here
  void sortItems(String value) {
    // assuming the original list is stored _listings
    _sortedListings = _listings;
    switch (value) {
      case 'Default':
        _sortedListings.sort(
            (first, second) => first.supermarket.compareTo(second.supermarket));
        break;
      case 'By Name':
        _sortedListings
            .sort((first, second) => first.product.compareTo(second.product));
        break;
      case 'By Brand':
        _sortedListings
            .sort((first, second) => first.brand.compareTo(second.brand));
        break;
      case 'By Price':
        _sortedListings
            .sort((first, second) => first.price.compareTo(second.price));
        break;

      default:
        break;
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pushNamed(HcsProductsSearchResultsScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    }
  }

  @override
  List<Widget> _buildActions() => <Widget>[
        DropdownButton<String>(
          // underline: Container(),
          icon: Icon(
            Icons.sort,
            color: Colors.white,
            size: 26,
          ),
          items: dropDown.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                width: 50,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              sortItems(value);
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
            Navigator.of(context).pushNamed(
              ShoppingListScreen.routeName,
            );
          },
          color: Colors.grey,
          tooltip: 'Cart',
        ),
    
      ];



  @override
  void didChangeDependencies() {
    final query = ModalRoute.of(context).settings.arguments as String;
    SupermarketServices.getListing(query).then((listings) {
      setState(() {
        _listings = listings;
        _sortedListings = _listings;
        _loading = false;
      });
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Supermarket Listings"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,

        actions: _buildActions(),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : _sortedListings.isEmpty == false
              ? ListView.builder(
                  itemCount:
                      _sortedListings == null ? 0 : _sortedListings.length,
                  itemBuilder: (context, index) {
                    print(_sortedListings);
                    SupermarketListing listing = _sortedListings[index];
                    return SupermarketItem(listing, false);
                  },
                )
              : Center(
                  child: Text('No results found.'),
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
