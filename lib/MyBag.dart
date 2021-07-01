import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:e_commerce/ProductDetails.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';



var bagItemArray=[];

class MyBag extends StatefulWidget {
  @override
  _MyBagState createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {

  var _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var allItems;

  void initState(){
    super.initState();

    getBagItemArray();
  }

  void getBagItemArray() async{

    await _firestore
        .collection('Users')
        .doc(_firebaseAuth.currentUser.phoneNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        bagItemArray=documentSnapshot.get('Bag');
        allItems=StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('productDetails').snapshots(),
          builder: (context, snapshot) {
            List<BagWidget> bagItems = [];
            if (snapshot.hasData) {
              final displayData = snapshot.data.docs;
              for (var eachProduct in displayData) {
                if (bagItemArray.contains(eachProduct.id)) {
                  var bagItemWidget=BagWidget(
                    productId:eachProduct.id,
                    productName: eachProduct.get('Name'),
                    price: eachProduct.get('Price'),
                    imageUrl: eachProduct.get('imageUrls')[0],
                  );
                  bagItems.add(bagItemWidget);
                }
              }
            }
            return Expanded(
              child: ListView(
                  shrinkWrap: true,
                  children: bagItems
              ),
            );
          },
        );

      } else {
        print('Document does not exist on the database');
      }
    });
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My Bag',
            style: TextStyle(color: Colors.white)),
      ),
    body: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: Container(
              margin: EdgeInsets.all(2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 1),
                child: Text(
                  "Your Cart Products",
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
        (allItems)??Center(child: Text("Loading..."),)
      ],
    )

    );
  }
}

class BagWidget extends StatelessWidget {

  var productId;
  var productName;
  var price;
  var imageUrl;
  var _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  BagWidget({this.productId,this.productName,this.price,this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductDetails(
              productId: productId,
              productName: productName,
            );
          }));
        },
        child: Card(
          elevation: 9,
          child: Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end:Alignment.centerRight,
                    colors: [Colors.white24,
                      Colors.white54
                    ]

                )
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      child: Column(children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(
                                child: LoadingJumpingLine.circle(
                                  size: 30,
                                  backgroundColor: Color(0xfffca9e4),
                                )
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ])
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Text('$productName',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Text(' ₹  $price',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: GFColors.SUCCESS),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GFButton(
                          onPressed: () {

                            CollectionReference users = _firestore.collection('Users');

                            users.doc(_firebaseAuth.currentUser.phoneNumber)
                                  .update({'Bag': FieldValue.delete()})
                                  .then((value) => print("User Deleted"))
                                  .catchError((error) => print("Failed to delete user: $error"));

                            bagItemArray.remove(this.productId);

                            users.doc(_firebaseAuth.currentUser.phoneNumber)
                                  .update({'Bag': bagItemArray})
                                  .then((value) => print("User Deleted"))
                                  .catchError((error) => print("Failed to delete user: $error"));

                            Fluttertoast.showToast(
                                msg: 'Item will be removed,Don\'t worry',
                                textColor: Colors.white,
                                backgroundColor: GFColors.DARK
                            );
                          },
                          shape: GFButtonShape.pills,
                          color: GFColors.SECONDARY,
                          size: GFSize.MEDIUM,
                          text:"Remove"
                        ),
                      )

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
