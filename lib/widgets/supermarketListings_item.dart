import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/models/supermarket_listing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/shoppingList.dart';
import '../providers/auth.dart';

// Class to handle the UI subcomponent for a specific supermarket listing 

class SupermarketItem extends StatelessWidget {

  SupermarketListing listing;
  bool inCart;

  SupermarketItem(@required this.listing, this.inCart);



  @override
  Widget build(BuildContext context) {
    double price = listing.price;
    return inCart
        ? Dismissible(
            key: UniqueKey(),
            // ValueKey(id), //needs a key to avoid issues where it displays a incorrectly rendered list
            background: Container(
                color: Colors.red,
                child: Icon(
                  Icons
                      .delete, //show the delete icon to indicate that swiping the item means to delete it
                  color: Colors.white,
                  size: 40,
                ),
                alignment: Alignment
                    .centerRight, //to move the icon to the right so that it is visible when swiping
                padding: EdgeInsets.only(
                  //put some space between the icon and the end of the screen to make it look nicer
                  right: 20,
                ),
                margin: EdgeInsets.symmetric(
                  //this ensures the background is only behind the card
                  horizontal: 15,
                  vertical: 4,
                )),
            direction: DismissDirection
                .endToStart, //restricts the swiping to only from right to left
            confirmDismiss: (direction) {
              return showDialog(
                //showDidalog returns a future, a future is a object which will eventually return a boolean result as it has to tell flutter if we want to dismiss or not
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text(
                    'Do you want to remove the item from the shopping list?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(
                            false); //Controls what the future resolves to by forwarding/passing the value to navigator pop. False in this case to unconfirm the dismissal
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(
                            true); //Controls what the future resolves to by forwarding/passing the value to navigator pop. False in this case to confirm the dismissal
                      },
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              //direction is accepted as an argument in the event the widget can be swiped in 2 direcrtions, this is used to inCart which direction it was swiped
              Provider.of<ShoppingList>(context, listen: false).deleteListing(
                listing.product,
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    listing.imageurl,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Text('No image available');
                    },
                  ),
                  title: Text(listing.product),
                  subtitle: Text(price.toString()),
                ),
              ),
            ),
          )
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 1,
            child: Row(
              children: [
                SizedBox(
                    width: 100,
                    height: 130,
                    child: Container(
                      child: Image.network(listing.imageurl),
                    )
                    
                    ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: listing.supermarket,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: listing.supermarket == 'Cold Storage'
                                ? Colors.red
                                : Colors.green),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: listing.brand,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 170,
                      child: Expanded(
                        child: Text(
                          listing.product,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          // maxLines: 2,
                          // overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        // text: "\$$price",
                        text: "\$" + price.toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.orange),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.favorite_border_outlined),
                      // ),

                      IconButton(
                        onPressed: () {
                          bool authorised =
                              Provider.of<Auth>(context, listen: false).isAuth;
                          if (authorised) {
                            Provider.of<ShoppingList>(context, listen: false)
                                .addListing(listing);

                            bool message = Provider.of<ShoppingList>(context,
                                    listen: false)
                                .checker;

                            Scaffold.of(context)
                                .hideCurrentSnackBar(); //dismiss a existing snackbar for the new one to come out

                            if (!message) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  //a snackbar is just a material design object which is shown at the bottom of the screen
                                  content: Text(
                                    'This item has already been added!',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  //a snackbar is just a material design object which is shown at the bottom of the screen
                                  content: Text(
                                    'Added item to shopping list!',
                                  ),
                                  duration: Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      Provider.of<ShoppingList>(context,
                                              listen: false)
                                          .deleteListing(
                                        listing.product,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          } else {
                            Scaffold.of(context)
                                .hideCurrentSnackBar(); //dismiss a existing snackbar for the new one to come out

                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                //a snackbar is just a material design object which is shown at the bottom of the screen
                                content: Text(
                                  'Please log in first!',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          try {
                            if (listing.supermarket == 'Cold Storage') {
                              print('https://coldstorage.com.sg' +
                                  listing.redirectUrl);
                              launch('https://coldstorage.com.sg' +
                                  listing.redirectUrl);
                            } else {
                              print('https://giant.sg/' + listing.redirectUrl);
                              launch('https://giant.sg/' + listing.redirectUrl);
                            }
                          } catch (error) {
                            AlertDialog(
                              title: Text(
                                "Alert!!",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              content: Text(
                                'Sorry, we are unable to redirect you. Please try again later.',
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
                        },
                        icon: Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
