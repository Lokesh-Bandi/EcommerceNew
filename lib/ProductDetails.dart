import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:e_commerce/Payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:badges/badges.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'DetailsTable.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'MyBag.dart';




class ProductDetails extends StatefulWidget {
  String productId;
  String productName;
  @override
  ProductDetails({this.productId,this.productName});
  _ProductDetailsState createState() => _ProductDetailsState(productId: productId,productName: productName);
}

class _ProductDetailsState extends State<ProductDetails> {

  String productId;
  String productName;
  int price;
  double oldPrice;
  double offer;
  List<dynamic> imageUrls = [];
  var unsaved=Icon(CupertinoIcons.heart_fill,color: Colors.white);
  var saved=Icon(CupertinoIcons.heart_fill,color: Colors.redAccent);
  bool isSaved=false;

  static const rowStyle = TextStyle(fontSize: 16, color: Colors.black);
  String title = "Payment Easy";
  TextEditingController controller = TextEditingController();

  //Firebase variable
  var _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var bag=[];

  _ProductDetailsState({this.productId, this.productName});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          title: Text("Product Details",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_alt_sharp,
                color: Colors.white,
              ),
              onPressed: (){

              }),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MyBag();
                  }));
                }),
          )

        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Container(
                margin: EdgeInsets.all(2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 1),
                  child: Text(
                    productName,
                    style: TextStyle(
                        fontFamily: 'YuseiMagic',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: GFColors.FOCUS
                    ),),
                )
              ),
            ),
            Center(
              child: Container(
                width: 300,
                child: Divider(
                  thickness: 2,
                  color: Colors.grey.withOpacity(0.25),
                ),
              ),
            ),
            //carousel slider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('productDetails').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final productDetails = snapshot.data.docs;
                      for (var eachDetail in productDetails) {
                        if (eachDetail.id == productId) {
                          price = eachDetail.get('Price');
                          offer = eachDetail.get('Offer');
                          oldPrice = eachDetail.get('OldPrice');
                          imageUrls = eachDetail.get('imageUrls');
                        }
                      }
                    }
                    else {
                      CircularProgressIndicator();
                    }
                    return Card(
                        shadowColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
                        elevation: 9,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22)
                            ),
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: EdgeInsets.all(5),
                            height: 400,
                            child: PhotoViewGallery.builder(
                              itemCount: imageUrls.length,
                              builder: (context, index) {
                                return PhotoViewGalleryPageOptions(
                                  imageProvider: CachedNetworkImageProvider(
                                      imageUrls[index]),
                                  minScale: PhotoViewComputedScale.contained *
                                      0.8,
                                  maxScale: PhotoViewComputedScale.covered * 2,
                                );
                              },
                              scrollPhysics: BouncingScrollPhysics(),
                              backgroundDecoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)),
                                color: Theme
                                    .of(context)
                                    .canvasColor,
                              ),
                              enableRotation: true,
                              loadingBuilder: (context, event) =>
                                  Center(
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.orange,
                                        value: event == null
                                            ? 0
                                            : event.cumulativeBytesLoaded /
                                            event.expectedTotalBytes,
                                      ),
                                    ),
                                  ),
                            )
                        )
                    );
                  }

              ),
            ),
            //badges
            Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('productDetails').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final productDetails = snapshot.data.docs;
                        for (var eachDetail in productDetails) {
                          if (eachDetail.id == productId) {
                            price = eachDetail.get('Price');
                            offer = eachDetail.get('Offer');
                            oldPrice = eachDetail.get('OldPrice');
                          }
                        }
                      }
                      return Column(
                        children: [
                          //price,offer and old price
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Container(
                                    height: 50,
                                    child: Badge(
                                      elevation: 7,
                                      toAnimate: false,
                                      shape: BadgeShape.square,
                                      badgeColor: Colors.black87,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomLeft: Radius.circular(25)
                                      ),
                                      badgeContent: Center(
                                        child:
                                        Text(
                                            '₹ ' + price.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    child: Badge(
                                      elevation: 7,
                                      toAnimate: false,
                                      shape: BadgeShape.square,
                                      badgeColor: Colors.yellow,
                                      borderRadius: BorderRadius.circular(16),
                                      badgeContent: Center(
                                        child: Text('- ' +
                                            offer.toString() + ' %',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Container(
                                    height: 40,
                                    width: 80,
                                    child: Badge(
                                      elevation: 7,
                                      toAnimate: false,
                                      shape: BadgeShape.square,
                                      badgeColor: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(
                                        child: Text(
                                            '₹ ' + oldPrice.toString(),
                                            style: TextStyle(
                                                decoration: TextDecoration
                                                    .lineThrough,
                                                fontSize: 17,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // assured product and rating badges
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  child: Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(8),
                                    badgeContent: Center(
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.tag_fill,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          Text(
                                              '  Our Assured Product',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16,
                                                  color: Colors.white)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Container(
                                  height: 40,
                                  width: 60,
                                  child: Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(8),
                                    badgeContent: Center(
                                      child: Row(
                                        children: [
                                          Text(
                                              '  4 ', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              color: Colors.white)
                                          ),
                                          Icon(
                                            CupertinoIcons.star_circle_fill,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                )
            ),
            //details
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: DetailsTable(
                  productId: productId, productName: productName),
            ),
            //button

            // Place order button
            Container(
              height: 60,
              margin: EdgeInsets.only(top: 8, bottom: 6, left: 15, right: 15),
              child: GFButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return PaymentScreen(productId: productId,
                        productName: productName,
                        price: price,);
                    }));
                  },
                  shape: GFButtonShape.pills,
                  size: GFSize.LARGE,
                  color: GFColors.INFO,
                  child: Text("Make Payment",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: GFColors.WHITE
                    ),)),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            var getData=StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final displayData = snapshot.data.docs;
                    for (var eachProduct in displayData) {
                      if (eachProduct.id==_firebaseAuth.currentUser.phoneNumber) {
                        bag = eachProduct.get('Bag');
                      }
                    }
                  }
                  return Text('Empty');
                }
            );

            if(isSaved==false){
              isSaved=true;
              bag.add(this.productId);
              print(bag);
              _firestore.collection('Users').doc(_firebaseAuth.currentUser.phoneNumber).update(
                  {'Bag': FieldValue.arrayUnion(bag)}
              ).then((_) {
                Fluttertoast.showToast(
                    msg: 'Added to Wishlist',
                    textColor: Colors.white,
                    backgroundColor: GFColors.DARK
                );
              });
            }

            else{

                Fluttertoast.showToast(
                    msg: 'Remove product from manually',
                    textColor: Colors.white,
                    backgroundColor: GFColors.DARK
                );
            }
          });

        },
        backgroundColor:GFColors.FOCUS,
        child:isSaved==true?saved:unsaved,
      ),
    );
  }

}

