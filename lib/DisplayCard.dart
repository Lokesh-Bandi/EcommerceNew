import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/MyBag.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:geocoding/geocoding.dart';


// ignore: must_be_immutable
class DisplayCard extends StatefulWidget {
  String productId;
  String productName;
  String offeredBy;
  int price;
  double offer;
  double oldPrice;
  String imageUrl;
  var geoPoint;
  List<String> reviews;


  DisplayCard(
      {Key key,
        this.productId,
        this.productName,
        this.offeredBy,
        this.price,
        this.offer,
        this.oldPrice,
        this.imageUrl,
        this.reviews,
      this.geoPoint})
      : super(key: key);

  @override
  _DisplayCardState createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  var unsaved=Icon(CupertinoIcons.heart);

  var saved=Icon(CupertinoIcons.heart_fill,color: GFColors.WARNING);

  var isSaved=false;
  List<Placemark> placeMarks=[];

  initState(){
    super.initState();
    getAddress();
  }

  getAddress() async{
    placeMarks = await placemarkFromCoordinates(this.widget.geoPoint.latitude, this.widget.geoPoint.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductDetails(productId: this.widget.productId,productName:this.widget.productName);
          }));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          shadowColor: Colors.grey,
          elevation: 4,
          child: Container(
            padding: EdgeInsets.fromLTRB(3, 5, 3, 0),
            height: 220,
            width: double.maxFinite,
            child: Column(
              children: [
                //Product name
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Wrap(children: [
                        Text(
                          widget.productName,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'YuseiMagic'),
                        ),
                      ]),
                    ),
                  ),
                ),

                //Image and Details
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      //Image
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: widget.imageUrl,
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
                      ),

                      //Details
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "By "+widget.offeredBy,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black,fontFamily: 'EBGaramond'),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "₹${widget.price}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹${widget.oldPrice}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 1),
                                child: Text(
                                  "OFFER ${widget.offer}%",
                                  style: TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
                                child: Text(
                                  "view >>",
                                  style: TextStyle(
                                    fontFamily: 'EBGaramond',
                                      letterSpacing: 3,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              IconButton(
                                  icon: isSaved?saved:unsaved,
                                  onPressed:(){
                                      setState(() {
                                        if (isSaved==true){
                                          isSaved=false;
                                        }
                                        else{
                                          isSaved=true;

                                        }
                                      });
                              })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
