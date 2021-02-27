import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homie_app/models/User.dart';
import 'package:homie_app/pages/create_account.dart';
import 'package:homie_app/pages/profile.dart';
import 'package:homie_app/pages/search.dart';
import 'package:homie_app/pages/timeline.dart';
import 'package:homie_app/pages/upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection("posts");
final timelineRef = FirebaseFirestore.instance.collection("timeline");
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    //detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('error signing in: $err');
    });
    //reauthenticate when app reopened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) async{
    if (account != null) {
      await createUserInFirestore();
      print('user signed in: $account');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    //check if user exists in users collection database, according to their id
    currentUser = User();
    final GoogleSignInAccount user = (await googleSignIn.currentUser);
    DocumentSnapshot userDocSnap = await usersRef.doc(user.id).get();
    if (!userDocSnap.exists || userDocSnap == null) {
      //if not we take them to registration page
      final displayName = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );
      //get user name from registration page, use it to make new users in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        // "username": username,
        "photoUrl": user.photoUrl,
        "bio": "",
        "email": user.email,
        "timestamp": timestamp,
        "display name": displayName,
      });
      userDocSnap = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(userDocSnap);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTabBarTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  bool isAuth = false;

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          Timeline(currentUser: currentUser),
          // ElevatedButton(
          //   onPressed: logout,
          //   child: Text("logout"),
          // ),
          Upload(),
          Search(),
          Profile(profileId: currentUser.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTabBarTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications_active),
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
    );

    // ElevatedButton(
    //   onPressed: logout,
    //   child: Text("Log Out"),
    // );
  }

  Scaffold unAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal[400],Colors.teal, Colors.green[700]]),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Homies App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Find a home easily",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: login,
                  child: Container(
                    height: 60,
                    width: 260,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/google_signin_button.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : unAuthScreen();
  }
}
