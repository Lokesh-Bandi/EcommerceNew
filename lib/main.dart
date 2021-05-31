import 'dart:async';
import 'package:e_commerce/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/InsertDeleteHomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:e_commerce/HomeReference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

bool alreadyVisited=false;

Map<int, Color> color =
{
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};

MaterialColor drawerColor=MaterialColor(0xfffca9e4,color);

bool isOpen=false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs= await SharedPreferences.getInstance();
  alreadyVisited=prefs.getBool('alreadyVisited');
  runApp(MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: drawerColor,
        secondaryHeaderColor: Colors.blue,
          primaryColor: Color(0xfffca9e4)
      ),
      home: SafeArea(child: (alreadyVisited!=null)?(HomePage()):(LoginScreen())))
  );
}

class CheckInternet {
  // ignore: cancel_subscriptions
  StreamSubscription<DataConnectionStatus> listener;
  var internetStatus ;
  var contentMessage ;
  bool ourStatus;


  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          internetStatus = "You are Connected";
          contentMessage = Image.asset("Images/hasInternet.gif",width: 60,height: 60,);
          ourStatus=true;
          break;
        case DataConnectionStatus.disconnected:
          internetStatus = "You are disconnected to the Internet. ";
          contentMessage = Image.asset("Images/noInternet.gif",width: 60,height: 60,);
          ourStatus=false;
          if(isOpen==false) {
            _showDialog(internetStatus, contentMessage, ourStatus, context);
          }
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title, Image content,bool outStatus, BuildContext context) {
    isOpen=true;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: content,
              title: Text(title),
              actions: <Widget>[
                 FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:(ourStatus)?Text("Welcome"):Text('TryAgain'))
              ]
          );
        }
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  void initState(){
    super.initState();
    CheckInternet().checkConnection(this.context);
  }

  void dispose() {
    CheckInternet().listener.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            )),
        body: Builder(
          builder: (context)=>Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return HomeReference();
                        }));
                      },
                      child: Text("Click"),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: RaisedButton(
                      onPressed: (){
                        //server.start();
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return InsertDeleteHomePage();
                        }));
                      },
                      child: Text("Insertion"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                    height: 320,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 9,
                    ),
                  ),
                ],
              )
          )
          ,
        )    );
  }
}

// ignore: must_be_immutab