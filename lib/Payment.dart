import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:e_commerce/DetailsTable.dart';
import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'AddressForm.dart';
import 'Addresses.dart';


class PaymentScreen extends StatefulWidget {
  String productId;
  String productName;
  int price;
  PaymentScreen({this.productId,this.productName,this.price});
  _PaymentScreenState createState() => _PaymentScreenState(productId: productId,productName: productName,price:price);
}

class _PaymentScreenState extends State<PaymentScreen> {
  String productId;
  String productName;
  int price;
  _PaymentScreenState({this.productId,this.productName,this.price});
  @override
  Razorpay razorpay=Razorpay();
  TextEditingController controller= TextEditingController();
  static const rowStyle=TextStyle(fontSize: 16,color: Colors.black);

  FirebaseAuth _firebaseAuth;
  final firestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;
  var uploadingTime;

  // ignore: must_call_super
  void initState(){
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    controller.text=price.toString();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
  }
  void dispose(){
    super.dispose();
    razorpay.clear();
  }
  void openCheckOut(){
    var options={
      'key':'rzp_test_gjA9z87B9iEVa6',
      'amount': double.parse(price.toString())*100,
      'name':_firebaseAuth.currentUser.displayName,
      'Description': 'Money payment to Silicon',
      'prefill':{
          'contact':_firebaseAuth.currentUser.phoneNumber,
          'email':_firebaseAuth.currentUser.email,
        },
      'theme':{
        'color':"#27e6f7"
      },
      'external':{
        'wallets':['paytm','phonepay']
    }
    };
    razorpay.open(options);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response){
    firestore.collection('OrdersPlaced').add({
      'CustomerName': _firebaseAuth.currentUser.displayName,
      'CustomerPhoneNumber':_firebaseAuth.currentUser.phoneNumber,
      'CustomerEmail':_firebaseAuth.currentUser.email,
      'PaymentID':response.paymentId,
      'ProductID':productId,
      'OrderID':response.orderId,
      'ProductName':productName,
      'Price':price,
      'Time':DateTime.now()
    }
    );
  }
  void _handleExternalWallet(ExternalWalletResponse response){
    print("Payment success in wallet"+response.toString());
  }
  void _handlePaymentError(PaymentFailureResponse response){
    print("Payment Failed");
  }
  Widget build(BuildContext context) {

    var address=Addresses(context: context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: Text("Payment Details",
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

                }),
          )

        ],
      ),
      body: ListView(
        children: [
          //product summary
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5, horizontal: 5),
            child: Container(
              height:50,
              child: Badge(
                elevation: 7,
                toAnimate: false,
                shape: BadgeShape.square,
                badgeColor: GFColors.INFO,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)
                ),
                badgeContent: Center(
                  child:
                  Text(
                      'Your Product Summary',
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
          //product details
          DetailsTable(productId: productId,productName: productName,),
          //amount field
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal:10),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextFormField(
                    controller: controller,
                    enabled: false,
                    textAlign: TextAlign.justify,
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                    decoration: InputDecoration(
                      labelText:'Product Price',
                        hintText: "Enter the amount",
                        prefixText: 'Total Amount : ₹  ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                )
            ),
          ),

          //Select your address
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 0,bottom:6,left: 15,right: 15),
            child: GFButton(
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                            child:ListView(
                                children:[
                                  ListTile(
                                    leading:Icon(CupertinoIcons.home),
                                    title:Text('Select Your Address'),
                                    subtitle: Text('Delivery Address'),
                                    trailing: GestureDetector(
                                        onTap: (){
                                          showDialog(context: context, builder:(BuildContext context){
                                            return AddressForm();
                                          });
                                        },
                                        child: Icon(CupertinoIcons.add,size: 30,color: Colors.black,
                                        )
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  // Address()
                                  address.getAddresses()

                                ]

                            )
                        ),
                      );
                    });
              },
              child:Text("Select your shipping address ▼",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GFColors.WHITE
                ),
              ),
              shape: GFButtonShape.pills,
              splashColor: GFColors.SUCCESS,
              boxShadow: BoxShadow(
                color: Colors.grey,
                blurRadius: 20.0, // soften the shadow
                offset: Offset(
                  7,
                  7// Move to bottom 10 Vertically
                ),
              ),
              size: GFSize.LARGE,
              color: GFColors.WARNING,
            ),
          ),

          //Make Payment button
          Container(
            height: 60,
            margin: EdgeInsets.only(top: 8,bottom:6,left: 15,right: 15),
            child: GFButton(
                    onPressed:(){
                      openCheckOut();
                    },
                    shape: GFButtonShape.pills,
                    fullWidthButton: true,
                    size: GFSize.LARGE,
                    color: GFColors.INFO,
                    child:Text("Make Payment",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: GFColors.WHITE
                      ),)),
              ),

        ],
      ),
    );
  }
}
