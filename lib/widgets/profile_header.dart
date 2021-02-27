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
      isAppTitle ? "flutter share" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontSize: isAppTitle ? 50 : 20,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    backgroundColor: Theme.of(context).primaryColor,
    // centerTitle: true,
    actions: [
      Container(
        color: Colors.blue,
        child: ElevatedButton(
          onPressed: logout,
          child: Text("Log Out"),
        ),
      ),
    ],
  );
}
