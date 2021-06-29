import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:e_commerce/ImageWidgetConstants.dart';


var downloadUrl;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  //display image

  bool isCamera;
  bool isLoading=false;
  var uploadingTime;

  //Firebase variable
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Profile view
  TextEditingController nameEditor=TextEditingController();
  TextEditingController emailEditor=TextEditingController();

  //Animation variables
  AnimationController logoController;
  AnimationController bodyController;
  Animation animation;
  Animation loginAnimation;
  Animation registerAnimation;
  String phoneNumber;
  final _codeController = TextEditingController();

  File file;

  var _formKey = GlobalKey<FormState>();

  //InputDecoration

  void initState() {
    super.initState();
    logoController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(
        seconds: 2,
      ),
    );
    bodyController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(
        seconds: 2,
      ),
    );

    animation = ColorTween(begin: Colors.lightBlueAccent, end: Colors.white)
        .animate(bodyController);
    loginAnimation =
        ColorTween(begin: Colors.white, end: Colors.lightBlueAccent)
            .animate(bodyController);
    registerAnimation = ColorTween(begin: Colors.white, end: Colors.blueAccent)
        .animate(bodyController);
    logoController.forward();
    logoController.addListener(() {
      setState(() {});
    });
    bodyController.forward();
    bodyController.addListener(() {
      setState(() {});
    });
  }

  Future<bool> loginUser(String phone, BuildContext context) async {

      List<String> currentIDs;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          var result = await _auth.signInWithCredential(credential);

          // ignore: deprecated_member_use
          final user = result.user;

          if (user != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('alreadyVisited', true);

            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return HomePage();
            }));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter the OTP"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        // ignore: deprecated_member_use
                        AuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: code);
                        var result =
                        await _auth.signInWithCredential(credential);

                        // ignore: deprecated_member_use
                        final user = result.user;

                        if (user != null) {
                          SharedPreferences prefs = await SharedPreferences
                              .getInstance();
                          prefs.setBool('alreadyVisited', true);
                          user.updateProfile(
                            displayName: nameEditor.text,
                            photoURL: (Constants.imageUrl==null)?"https://ibb.co/M2GdhSr":Constants.imageUrl
                          );
                          user.updateEmail(emailEditor.text);

                          // var allAddresses= StreamBuilder<QuerySnapshot>(
                          //     stream: _firestore.collection('Users').snapshots(),
                          //     builder: (context, snapshot) {
                          //
                          //       if (snapshot.hasData) {
                          //         print("firstIF");
                          //         final displayData = snapshot.data.docs;
                          //         for (var eachProduct in displayData) {
                          //             currentIDs.add(eachProduct.id);
                          //             print(eachProduct.id);
                          //         }
                          //         if (currentIDs.contains(user.phoneNumber)){
                          //           print("2if");
                          //           _firestore.collection('Users').doc(
                          //               user.phoneNumber).update({
                          //             'Active': 'true'
                          //           });
                          //         }
                          //         else {
                          //           print('else');
                          //
                          //         }
                          //       }
                          //
                          //       return Text('');
                          //     }
                          // ) ;
                          Constants.imageEmpty= Constants.imageStatusFail;
                          _firestore.collection('Users').doc(user.phoneNumber).set({
                            'Active':'true',
                            'Addresses':[],
                            'Orders':[],
                            'Bag':[]
                          });


                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                                return HomePage();
                              }));
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (id) {
          print(id);
        });
  }

  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Builder(
        builder:(context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key:  _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Hero(
                            tag: 'logo',
                            child: Container(
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                size: 40,
                                color: Color(0xfffca9e4),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            'Your Best',
                            style: TextStyle(
                              color: Color(0xfffca9e4),
                                fontSize: 35.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Lobster'),
                          ),
                        ),
                        Expanded(
                          flex:4,
                          child: ScaleAnimatedTextKit(
                            text: ['Keep', 'Make', 'Fun'],
                            textStyle: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Lobster'),
                            textAlign: TextAlign.start,
                            //alignment: AlignmentDirectional.topStart
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [

                      ],
                    ),
                    //Name
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          maxLength: 30,
                          maxLengthEnforced: false,
                          textCapitalization: TextCapitalization.words,
                          onFieldSubmitted: (value){
                            setState(() {
                              _submit();
                            });
                          },
                          validator: (value){
                            final RegExp nameRegExp = RegExp('^[A-Za-z]');
                            return (value.isEmpty)
                                ? 'Enter Your Name'
                                : (nameRegExp.hasMatch(value)
                                ? null
                                : 'Enter a Valid Name');
                          },
                          controller: nameEditor,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: buildInputDecoration('Full name','Enter the name',Icons.perm_contact_cal),
                        ),
                      ),
                    ),
                    //Email
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value){
                            setState(() {
                              _submit();
                            });
                          },
                          validator: (value){
                            final RegExp emailExp=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                            return (value.isEmpty)
                                ? 'Enter Your Valid Email'
                                : (emailExp.hasMatch(value)
                                ? null
                                : 'Enter a Valid Email');
                          },
                          controller: emailEditor,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: buildInputDecoration('Email','Enter the email',Icons.email)
                        ),
                      ),
                    ),
                    //DisplayImage
                    buildImageUploadWidget(),


                    //Phone number
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value){
                            setState(() {
                              _submit();
                            });
                          },
                          validator: (value){
                            final RegExp emailExp=RegExp('[0-9]');
                            return (value.isEmpty)
                                ? 'Enter Your mobile'
                                : (emailExp.hasMatch(value)
                                ? null
                                : 'Enter a Valid number');
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            phoneNumber = '+91'+value;
                          },
                          decoration:buildInputDecoration('Mobile number','Enter the mobile number',Icons.phone)
                        ),
                      ),
                    ),
                    //SignIn button
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Color(0xfffca9e4),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton (
                          onPressed: () async{
                            if(_formKey.currentState.validate()) {
                              await loginUser(phoneNumber, context);
                            }
                            else
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content:Text('Enter the valid Details'),
                                    duration: Duration(seconds: 15),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: ()=>Navigator.pop(context),
                                      textColor: Colors.greenAccent,
                                    ),
                                )
                              );
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'SignIn',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //InputDecoration for textFields
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

  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      print("not saved");
      return;
    }
    _formKey.currentState.save();
  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      if(isCamera) {
        image = await _imagePicker.getImage(source: ImageSource.camera, imageQuality: 25);
        await CropingImage(image.path);
      }
      else {
        image = await _imagePicker.getImage(
            source: ImageSource.gallery, imageQuality: 25);
        await CropingImage(image.path);
      }
      if (image != null) {
        //to start cicularprogressindicator
        setState(() {
          isLoading = true;
        });
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('UserProfiles/${Path.basename(file.path)}')
            .putFile(file);
        downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          if (downloadUrl.isNotEmpty) {
            isLoading=false;
            Constants.imageUrl=downloadUrl;
            Constants.imageEmpty= Constants.imageStatusSuccess;
          }
          else
            Constants.imageEmpty= Constants.imageStatusFail;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

   CropingImage(String image) async{
    File _croppedImage= await ImageCropper.cropImage(
        sourcePath: image,
        aspectRatio: CropAspectRatio(ratioX: 1.0,ratioY: 1.0)
    );
    if(_croppedImage!=null){
      setState(() {
        file=_croppedImage;
      });

    }
  }

  Stack buildImageUploadWidget() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(
                        Radius.circular(30)
              ),
            ),
            child: ListTile(
              focusColor: Colors.grey,
              leading: GestureDetector(
                  onTap: () {
                    if (Constants.imageEmpty!= Constants.imageStatusSuccess) {
                      setState(() {
                        isCamera = true;
                        uploadImage();
                      });
                    }
                  },
                  child: Icon(Icons.add_a_photo)),
              title: Text(
                "Profile Image",
                textScaleFactor: 1.3,
              ),
              trailing: GestureDetector(
                  onTap: () {
                    if (Constants.imageEmpty!= Constants.imageStatusSuccess) {
                      setState(() {
                        isCamera = false;
                        uploadImage();
                      });
                    }
                  },
                  child: Constants.imageEmpty),
            ),
          ),
        ),
        isLoading?Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            strokeWidth: 4,),
        ):(Center()),
      ],
    );
  }

}
