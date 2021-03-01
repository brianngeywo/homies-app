import 'package:flutter/material.dart';
import 'package:homie_app/pages/home.dart';

logout() {
  googleSignIn.signOut();
}

AppBar profileHeader(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontSize: isAppTitle ? 50 : 20,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    backgroundColor: Colors.blueGrey[900].withBlue(110),
    elevation: 0,
    // centerTitle: true,
    actions: [
      Container(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent[700].withOpacity(0.7)),
          ),
          onPressed: logout,
          child: Text("Log Out"),
        ),
      ),
    ],
  );
}
