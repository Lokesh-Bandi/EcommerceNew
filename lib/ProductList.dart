import 'package:e_commerce/MyBag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/DisplayCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';



// ignore: must_be_immutable
class ProductList extends StatefulWidget {
  String screenName;
  int distanceRange;

  ProductList({this.screenName,this.distanceRange});

  _ProductListState createState() => _ProductListState(screenName,distanceRange);
}

class _ProductListState extends State<ProductList> {
  String productId;
  String productName;
  String offeredBy ;
  double offer ;
  double oldPrice ;
  int price ;
  int rating ;
  String screenName;
  var currentTime;
  String imageUrl = '';
  String latitude;
  String longitude;
  var geoPoint;
  int distanceRange;
  Position position;
  int productsCount;

  List<String> reviews;
  final _firestore = FirebaseFirestore.instance;
  bool isLoading=true;

  var productList;


  _ProductListState(this.screenName,this.distanceRange);



  // ignore: must_call_super
   void initState()  {
    isLoading=true;

    Future.delayed(Duration( milliseconds: 1470),(){
      setState(() {
        isLoading=false;
      });
    });
    getCurrentPosition();


  }

  void getCurrentPosition() async{
    position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    getProductLists();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(

                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        child: ListView(children: [
                          ListTile(
                            leading:
                            Icon(
                                Icons.filter_alt_sharp,
                                size: GFSize.MEDIUM,
                              color: GFColors.INFO,
                            ),
                            title:
                            Text('Filter'),
                            subtitle:
                            Text('Our Products'),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                                    return ProductList(screenName: widget.screenName,distanceRange: 10);
                                  }));
                                  Fluttertoast.showToast(
                                      msg: 'We will update you in 5 secs',
                                      textColor: Colors.white,
                                      backgroundColor: GFColors.DARK);

                                },
                                child: ListTile(
                                  title:Text(
                                    "< 10 Kms"
                                  ),
                                  subtitle: Text("Products will be shown within 10 kms of radius"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                                      return ProductList(screenName: widget.screenName,distanceRange: 20);
                                    }));
                                  Fluttertoast.showToast(
                                      msg: 'We will update you in 5 secs',
                                      textColor: Colors.white,
                                      backgroundColor: GFColors.DARK);

                                },
                                child: ListTile(
                                  title:Text(
                                      "< 20 Kms"
                                  ),
                                  subtitle: Text("Products will be shown within 20 kms of radius"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                                    return ProductList(screenName: widget.screenName,distanceRange: 40);
                                  }));
                                  Fluttertoast.showToast(
                                      msg: 'We will update you in 5 secs',
                                      textColor: Colors.white,
                                      backgroundColor: GFColors.DARK);
                                },
                                child: ListTile(
                                  title:Text(
                                      "< 40 Kms"
                                  ),
                                  subtitle: Text("Products will be shown within 40 kms of radius"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                                    return ProductList(screenName: widget.screenName,distanceRange: 80);
                                  }));
                                  Fluttertoast.showToast(
                                      msg: 'We will update you in 5 secs',
                                      textColor: Colors.white,
                                      backgroundColor: GFColors.DARK);
                                },
                                child: ListTile(
                                  title:Text(
                                      "< 80 Kms"
                                  ),
                                  subtitle: Text("Products will be shown within 80 kms of radius"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                                    return ProductList(screenName: widget.screenName,distanceRange: 1000);
                                  }));
                                  Fluttertoast.showToast(
                                      msg: 'We will update you in 5 secs',
                                      textColor: Colors.white,
                                      backgroundColor: GFColors.DARK);
                                },
                                child: ListTile(
                                  title:Text(
                                      "From Anywhere"
                                  ),
                                  subtitle: Text("Products will be shown from all locations"),
                                ),
                              ),
                            ),
                          )
                        ]),

                    ),
                  );
                });
          },
          backgroundColor:GFColors.INFO ,
          child:Icon(Icons.filter_alt_sharp),
        ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: IconButton(
                              icon: Icon(CupertinoIcons.back),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        Expanded(
                          flex: 4,
                          child: ListTile(
                            title: Text(
                              screenName,
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: GFColors.INFO
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.favorite),
                                    onPressed: (){

                                    }),
                                IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                                        return MyBag();
                                      }));
                                    }),

                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 20,
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.only(left: 20),
                          scrollDirection: Axis.horizontal,
                          children: [
                            Text('Products Available :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54)),
                            Text((productsCount==null?"...":productsCount.toString())+"  "+"(Radius : $distanceRange Kms)" ?? 'Loading...',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54)),
                          ],
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 12.0, right: 12.0, bottom: 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child:ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        productList??
                            Container(
                                padding: EdgeInsets.only(
                                    bottom: 60
                                ),
                                height: MediaQuery.of(context).size.height,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadingBouncingGrid.circle(
                                      size: 70,
                                      backgroundColor: Color(0xfffca9e4),
                                      borderSize: 10,
                                    )
                                  ],
                                )
                            )
                      ],
                    ) ,
                  ),
                ],
              ),
            )
        )
    );
  }

  void getProductLists() async{

     setState(() {

       productList= StreamBuilder<QuerySnapshot>(
           stream: _firestore.collection('productDetails').orderBy('Time',descending: true).snapshots(),
           builder: (context,snapshot){
             List<DisplayCard> displayCards=[];
             if (snapshot.hasData) {
               final displayData = snapshot.data.docs;
               for (var eachProduct in displayData) {
                 geoPoint=eachProduct.get('Location');

                 double distance = Geolocator.distanceBetween(geoPoint.latitude,geoPoint.longitude,position.latitude ,position.longitude );
                 distance=distance/1000;
                 int ceilDist=distance.ceil();

                 productId = eachProduct.id;
                 productName = eachProduct.get('Name');
                 offeredBy = eachProduct.get('OfferedBy');
                 price = eachProduct.get('Price');
                 offer = eachProduct.get('Offer');
                 oldPrice = eachProduct.get('OldPrice');
                 imageUrl = eachProduct.get('imageUrls')[0];

                 final displayCardWidget = DisplayCard(
                   productId: productId,
                   productName: productName,
                   offeredBy: offeredBy,
                   price: price,
                   offer: offer,
                   oldPrice: oldPrice,
                   imageUrl: imageUrl,
                   geoPoint: geoPoint,
                 );
                 if(ceilDist<=distanceRange) {
                   displayCards.add(displayCardWidget);
                 }

               }
               productsCount=displayCards.length;
               return Column(
                 children: displayCards,
               );
             }
             return Column(
               children: [],
             );
           }
       );

     });


  }
}




