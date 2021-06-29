import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Customer{
  var name;
  var dob;
  var gender;
  var email;
  var profileImage;
  var mobileNumber;
  var customerId;
  var orders=[];
  var bag=[];

  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Customer({
    this.customerId
  });

  DocumentReference getName(){
    DocumentReference snapshots= _firestore.collection('Users').doc(_firebaseAuth.currentUser.phoneNumber);
    return snapshots;
  }
}

void main(){

  Customer c=Customer(customerId: '+919381275562');
  print(c.getName());
}