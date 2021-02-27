import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "Get Homes" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontSize: isAppTitle ? 30 : 30,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: true,
  );
}
