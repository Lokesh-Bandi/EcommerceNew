import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Addresses{

  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var firebaseAddresses=[];
  List<AddressWidget> addresses=[];
  var addressesFromFirebase;

  var context;
  Addresses({this.context});


  void getAddressesFromFirebase() async{

    addressesFromFirebase=StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            final displayData = snapshot.data.docs;
            firebaseAddresses.clear();
            addresses.clear();
            for (var eachProduct in displayData) {
              if (eachProduct.id==_firebaseAuth.currentUser.phoneNumber) {
                firebaseAddresses = eachProduct.get('Addresses');
                break;
              }
            }
            for(var i=0;i<firebaseAddresses.length;i++) {
              addresses.add(AddressWidget(firebaseAddresses:firebaseAddresses,firebaseAddress: firebaseAddresses[i].toString().split(",")));
            }
          }
          return Column(
            children: addresses,
          );
        }
    ) ;
  }

  //List of Addresses from firebase
  Widget getAddresses() {
    getAddressesFromFirebase();
    return addressesFromFirebase ;
  }

}


//Widget of AddressTile
// ignore: must_be_immutable
class AddressWidget extends StatelessWidget {
  AddressWidget({
    Key key,
    @required this.firebaseAddress,
    this.firebaseAddresses
  }) : super(key: key);

  final List firebaseAddress;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List firebaseAddresses;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(60)),
          color: Colors.yellowAccent.withOpacity(0.3)
      ),
      margin: EdgeInsets.all(8.0),

      child: InkWell(
        splashColor: Colors.black87,
        highlightColor: Colors.white,
        onTap: (){
          Future.delayed(
              Duration(milliseconds: 400),(){
            Navigator.pop(context);
          });
          Fluttertoast.showToast(
              msg: 'Succesfully Address Saved',
              textColor: Colors.white,
              backgroundColor: Colors.orangeAccent);
        },
        child: ListTile(
          leading: Icon(CupertinoIcons.location),
          title: Text(firebaseAddress[0]+", "+firebaseAddress[1]),
          subtitle: Text(firebaseAddress[2]+', '+firebaseAddress[3]+", "+firebaseAddress[4]),
          trailing:InkWell(
            onTap: () async{
              firebaseAddresses.remove(this.firebaseAddress[0]+','+this.firebaseAddress[1]+','+this.firebaseAddress[2]+','+this.firebaseAddress[3]+','+this.firebaseAddress[4]);
              _firestore.collection('Users').doc(_firebaseAuth.currentUser.phoneNumber).update({
                'Addresses':FieldValue.arrayUnion(firebaseAddresses)
              });

              },
              child: Icon(CupertinoIcons.clear_circled,size: 30,)
          )
        ),
      ),
    );
  }
}

