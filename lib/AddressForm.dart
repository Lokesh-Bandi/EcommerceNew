import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


// ignore: must_be_immutable
class AddressForm extends StatelessWidget {

  TextEditingController houseNoEditor=TextEditingController();
  TextEditingController streetEditor=TextEditingController();
  TextEditingController cityEditor=TextEditingController();
  TextEditingController districtEditor=TextEditingController();
  TextEditingController pinEditor=TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var firebaseAddresses=[];
  var firebaseData;

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: GFColors.TRANSPARENT,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 25,
              color: GFColors.WARNING
            ),
            ),
            IconButton(
              icon: Icon(
                  CupertinoIcons.clear_fill,
                color: GFColors.WARNING,
                size: 35,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        actions: [
          Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 500,
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                            controller: houseNoEditor,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            decoration:buildInputDecoration('HouseNo.','Enter the mobile number',Icons.person_pin)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 500,
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                            controller: streetEditor,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            decoration:buildInputDecoration('Street','Enter the street name',Icons.label_important)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 500,
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                            controller: cityEditor,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            decoration:buildInputDecoration('City','Enter the city name',Icons.local_activity)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 500,
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                            controller: pinEditor,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            decoration:buildInputDecoration('Pincode.','Enter the pincode',Icons.person_pin_circle_outlined)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 500,
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                            controller: districtEditor,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            decoration:buildInputDecoration('District','Enter the district name',Icons.landscape)
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: GFButton(
                        onPressed: () async{
                          var getData=StreamBuilder<QuerySnapshot>(
                              stream: _firestore.collection('Users').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final displayData = snapshot.data.docs;
                                  for (var eachProduct in displayData) {
                                    if (eachProduct.id==_firebaseAuth.currentUser.phoneNumber) {
                                      firebaseAddresses = eachProduct.get('Addresses');
                                    }
                                  }
                                }
                                return Text('Empty');
                              }
                          );
                          firebaseAddresses.add(houseNoEditor.text+','+streetEditor.text+','+pinEditor.text+','+cityEditor.text+','+districtEditor.text);
                          _firestore.collection('Users').doc(_firebaseAuth.currentUser.phoneNumber).update(
                              {'Addresses': FieldValue.arrayUnion(firebaseAddresses)}
                          );
                          Fluttertoast.showToast(
                              msg: 'Succesfully Address Added',
                              textColor: Colors.white,
                              backgroundColor: Colors.orangeAccent);
                          Navigator.pop(context);
                        },
                      fullWidthButton: true,
                      text: '   Add    ',
                      size: GFSize.LARGE,
                      shape: GFButtonShape.pills,
                      type: GFButtonType.solid,
                      textColor: GFColors.WHITE,
                      color: GFColors.INFO,
                      buttonBoxShadow: true,
                    ),
                  )
                ],
              ),
        )
      ]
      ),
    );
  }
}



InputDecoration buildInputDecoration(String labelText,String hintText,IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    counterText: "",
    labelText:labelText ,
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding:
    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Color(0xfffca9e4), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}
