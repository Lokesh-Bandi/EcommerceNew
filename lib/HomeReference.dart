import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/ProductList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/GoogleMaps.dart';
import 'package:e_commerce/CurrentPosition.dart';
import 'package:badges/badges.dart';
import 'package:getwidget/getwidget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeReference extends StatefulWidget {
  @override
  _HomeReferenceState createState() => _HomeReferenceState();
}

class _HomeReferenceState extends State<HomeReference> {
  List<SareesTypes> sareeList;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading;

  var deliveryAddress;

  List<String> todayStories = [
    "https://www.laxmipati.com/public/productimages/thumbnail/6541-A.jpg",
    "https://www.laxmipati.com/public/productimages/thumbnail/6540-A.jpg",
    "https://www.laxmipati.com/public/productimages/thumbnail/6545-A.jpg",
    "https://www.laxmipati.com/public/productimages/thumbnail/6543-A.jpg",
    "https://www.laxmipati.com/public/productimages/thumbnail/6524-A.jpg",
    "https://www.laxmipati.com/public/productimages/thumbnail/6514-A.jpg"
  ];

  List<String> newArrivals = [
    'https://www.laxmipati.com/public/productimages/thumbnail/6520-A.jpg',
    "https://www.laxmipati.com/public/productimages/thumbnail/6534-A.jpg",
    'https://www.laxmipati.com/public/productimages/thumbnail/6494-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/13119-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/13115-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/6379-A.jpg'
  ];

  List<String> topRated = [
    'https://www.laxmipati.com/public/productimages/thumbnail/6381-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/R-925-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/R-921-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/5460-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/6597-A.jpg',
    'https://www.laxmipati.com/public/productimages/thumbnail/6474-A.jpg'
  ];

  List<Color> bgColors = [
    Color(0xffC8E9F6),
    Color(0xffFFCADE),
    Color(0xffE6B9E6),
    Color(0xffAAFFAA),
    Color(0xffFFC0CB)
  ];

  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  var colorizeTextStyle = TextStyle(
      fontSize: 28.0, fontFamily: 'EBGaramond', fontWeight: FontWeight.bold);

  var carouselOffer = 4000;
  var screenLoading;

  void initState() {
    super.initState();
    sareeList = [];

    setState(() {
      isLoading = true;
    });

    screenLoading = true;
    Future.delayed(Duration( milliseconds: 1400),(){
      setState(() {
        screenLoading=false;
      });
    });

    getSareeTypes();
    getPosition();
  }

  //getting data from firebase
  void getSareeTypes() async {
    await for (var snapshot
        in _firestore.collection('SareeTypes').snapshots()) {
      for (var eachType in snapshot.docs) {
        var temp = SareesTypes(
            name: eachType.get('Saree Type'),
            imageUrl: eachType.get('ImageUrl'));
        sareeList.add(temp);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void getPosition() async {
    CurrentPosition position = CurrentPosition();
    deliveryAddress = await position.determinePosition();
    setState(() {});
  }

  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 230,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              imageUrl: _firebaseAuth.currentUser.photoURL,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        _firebaseAuth.currentUser.displayName,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'YuseiMagic',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          _firebaseAuth.currentUser.phoneNumber.toString()),
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        height: 30,
                        width: 150,
                        child: Center(
                            child: Text(
                          'View Profile',
                          style: TextStyle(
                              fontFamily: 'Lobster',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(color: Color(0xfffca9e4)),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_bag_rounded,
                size: 30,
              ),
              title: Text('My Bag'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.contact_mail,
                size: 30,
              ),
              title: Text('Contact us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.feedback,
                size: 30,
              ),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, size: 30),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Do you want to logout?"),
                        content: Image.asset('Images/tenor.gif',
                            height: 60, width: 60),
                        elevation: 30.0,
                        backgroundColor: Colors.white,
                        actions: [
                          FlatButton(
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.teal),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('alreadyVisited');
                              await _firebaseAuth.signOut().then((_) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return LoginScreen();
                                }));
                              });
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "HomeReference",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SimpleMap();
                }));
              },
              tooltip: 'Current Location',
              icon: Icon(CupertinoIcons.location))
        ],
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (screenLoading == false)
                  ? homePage1(context)
                  : Center(
                    child: LoadingBouncingGrid.circle(
                        size: 70,
                        backgroundColor: Color(0xfffca9e4),
                        borderSize: 10,
                      ),
                  ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                        child: Badge(
                      elevation: 7,
                      toAnimate: false,
                      shape: BadgeShape.square,
                      badgeColor: Color(0xfff4deee),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25)),
                      badgeContent: Center(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Text('Delivery Address : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54)),
                            Text(deliveryAddress ?? 'Loading...',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54)),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
                Expanded(
                  flex: 19,
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: sareeList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 8.0 / 12.0,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ProductList(
                                    screenName: sareeList[index].name);
                              }));
                            },
                            child: Card(
                                shadowColor: (index % 3 == 0)
                                    ? Colors.pinkAccent
                                    : ((index % 3 == 1
                                        ? Colors.deepPurpleAccent
                                        : Colors.yellowAccent)),
                                elevation: 9,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        width: double.maxFinite,
                                        child: Column(children: [
                                          Expanded(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  sareeList[index].imageUrl,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: LoadingFlipping
                                                          .square(
                                                borderColor: Color(0xfffca9e4),
                                                size: 30.0,
                                                backgroundColor:
                                                    Color(0xfffca9e4),
                                              )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          sareeList[index].name,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'YuseiMagic',
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Center(
                                          child: Text(
                                            'View all  >',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontFamily: 'Lemonada',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ))
                                  ],
                                )),
                          ));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded homePage1(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          //Top carousel
          GFCarousel(
            items: bgColors.map(
              (color) {
                return Container(
                  padding: EdgeInsets.only(bottom: 12.0, top: 4.0),
                  margin: EdgeInsets.all(12.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Stack(
                        children: [
                          Container(
                            color: color,
                          ),
                          Positioned(
                            left: 20,
                            top: 25,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Cashback',
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                              ],
                              isRepeatingAnimation: true,
                            ),
                          ),
                          Positioned(
                            bottom: 35,
                            left: 20,
                            right: 20,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'EBGaramond',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                      'Hurry up..!!! Cashback.... on purchase of Fancy Wear and Georgette Sarees'),
                                ],
                                isRepeatingAnimation: false,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            right: 20,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontFamily: 'EBGaramond',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText('Upto ₹ $carouselOffer *'),
                                ],
                                isRepeatingAnimation: false,
                              ),
                            ),
                          )
                        ],
                      )),
                );
              },
            ).toList(),
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            pauseAutoPlayOnTouch: Duration(seconds: 1),
            aspectRatio:
                (MediaQuery.of(context).orientation == Orientation.landscape)
                    ? 27 / 8
                    : 15 / 8,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            pagination: true,
            pagerSize: 8,
            passiveIndicator: Colors.grey,
            activeIndicator: Color(0xfffca9e4),
          ),

          //Today Stories
          Padding(
            padding: const EdgeInsets.only(
                top: 3.0, left: 12.0, right: 12.0, bottom: 0),
            child: SizedBox(
              child: Text(
                'Today Stories',
                textAlign: TextAlign.left,
                style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
            child: SizedBox(
              width: 250,
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
            child: Container(
              height: 80,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: todayStories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            width: 80,
                            imageUrl: todayStories[index],
                            placeholder: (context, url) => Center(
                                child: LoadingFlipping.circle(
                              borderColor: Color(0xfffca9e4),
                              size: 60.0,
                              backgroundColor: Color(0xfffca9e4),
                            )),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )),
                    );
                  }),
            ),
          ),

          //New Arrivals
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 12.0, right: 12.0, bottom: 0),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Arrivals',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'More ➜',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Color(0xffFCA9E4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 12.0, right: 12.0, bottom: 0),
            child: SizedBox(
              width: 250,
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          GFItemsCarousel(
            rowCount: 4,
            itemHeight: 105,
            children: newArrivals.map(
              (url) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 80,
                        imageUrl: url,
                        placeholder: (context, url) => Center(
                          child: LoadingBouncingGrid.circle(
                            size: 30,
                            backgroundColor: Color(0xfffca9e4),
                            borderSize: 10,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                );
              },
            ).toList(),
          ),

          //Top rated
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 12.0, right: 12.0, bottom: 0),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Rated',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'More ➜',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Color(0xfffca9e4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
            child: SizedBox(
              width: 250,
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          GFItemsCarousel(
            rowCount: 3,
            itemHeight: 150,
            children: topRated.map(
              (url) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 80,
                        imageUrl: url,
                        placeholder: (context, url) => Center(
                          child: LoadingBouncingGrid.circle(
                            size: 30,
                            backgroundColor: Color(0xfffca9e4),
                            borderSize: 10,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}

class SareesTypes {
  String name;
  String imageUrl;

  SareesTypes({@required this.name, @required this.imageUrl});
}
