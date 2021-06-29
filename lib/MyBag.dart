import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyBag extends StatefulWidget {
  @override
  _MyBagState createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {

  var _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var bagItemArray=[];


  void initState(){
    super.initState();

    getBagItemArray();
  }

  void getBagItemArray() async{


    var empty=StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Users').snapshots(),
      builder: (context, snapshot) {
        List<BagWidget> bagItems = [];
        if (snapshot.hasData) {
          final displayData = snapshot.data.docs;
          for (var eachProduct in displayData) {
            if (eachProduct.id==_firebaseAuth.currentUser.phoneNumber) {
              var bagItemArray = eachProduct.get('Bag');
            }
          }
        }
        return Text("empty");
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My Bag',
            style: TextStyle(color: Colors.white)),
      ),
    body: ListView(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('productDetails').snapshots(),
          builder: (context, snapshot) {
            List<BagWidget> bagItems = [];
            if (snapshot.hasData) {
              final displayData = snapshot.data.docs;
              for (var eachProduct in displayData) {
                // if (bagItemArray.contains(eachProduct.id)) {
                  var bagItemWidget=BagWidget(
                    productName: eachProduct.get('Name'),
                    price: eachProduct.get('Price'),
                    imageUrl: eachProduct.get('imageUrls')[0],
                  );
                  bagItems.add(bagItemWidget);
                // }
              }
            }
            return Column(
                children: bagItems
            );
          },
        )

      ],
    ),
    );
  }
}

class BagWidget extends StatelessWidget {

  var productName;
  var price;
  var imageUrl;
  BagWidget({this.productName,this.price,this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: CachedNetworkImage(
      //   imageUrl:imageUrl,
      //   imageBuilder: (context, imageProvider) =>
      //       Container(
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             image: imageProvider,
      //             fit: BoxFit.fill,
      //           ),
      //         ),
      //       ),
      //   placeholder: (context, url) => Center(
      //       child: CircularProgressIndicator()),
      //   errorWidget: (context, url, error) =>
      //       Icon(Icons.error),
      // ),
      title: Text("$productName"),
      subtitle: Text("$price"),
      onTap: (){

      },
    );
  }
}
