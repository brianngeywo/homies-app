import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homie_app/models/User.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/widgets/progress.dart';

class FullPost extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String mediaUrl;
  final String location;
  final String description;
  final String displayName;
  final String bedrooms;
  final String parking;
  final String bathrooms;
  final String internet;
  final String rent;
  final String phone;

  FullPost({
    this.postId,
    this.ownerId,
    this.mediaUrl,
    this.location,
    this.description,
    this.displayName,
    this.bathrooms,
    this.bedrooms,
    this.internet,
    this.parking,
    this.phone,
    this.rent,
  });
  factory FullPost.fromDocument(DocumentSnapshot postDocSnap) {
    return FullPost(
      postId: postDocSnap['postId'],
      ownerId: postDocSnap['ownerId'],
      location: postDocSnap['location'],
      description: postDocSnap['description'],
      mediaUrl: postDocSnap['medialUrl'],
      displayName: postDocSnap['display name'],
      bathrooms: postDocSnap['bathrooms'],
      bedrooms: postDocSnap['bedrooms'],
      internet: postDocSnap['internet'],
      parking: postDocSnap['parking'],
      phone: postDocSnap['phone'],
      rent: postDocSnap['rent'],
    );
  }
  @override
  _FullPostState createState() => _FullPostState(
        postId: this.postId,
        ownerId: this.ownerId,
        mediaUrl: this.mediaUrl,
        location: this.location,
        description: this.description,
        displayName: this.displayName,
        bedrooms: this.bedrooms,
        parking: this.parking,
        bathrooms: this.bathrooms,
        internet: this.internet,
        rent: this.rent,
        phone: this.phone,
      );
}

class _FullPostState extends State<FullPost> {
  final String postId;
  final String ownerId;
  final String mediaUrl;
  final String location;
  final String description;
  final String displayName;
  final String bedrooms;
  final String parking;
  final String bathrooms;
  final String internet;
  final String rent;
  final String phone;
  _FullPostState({
    this.postId,
    this.ownerId,
    this.mediaUrl,
    this.location,
    this.description,
    this.displayName,
    this.bathrooms,
    this.bedrooms,
    this.internet,
    this.parking,
    this.phone,
    this.rent,
  });
  buildPostHeader() {
    return FutureBuilder(
        future: usersRef.doc(widget.ownerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: circularProgress(),
            );
          }
          final User user = User.fromDocument(snapshot.data);
          return Container(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(location),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildPostImage() {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 275),
          child: Center(
            child: Image.network(
              mediaUrl,
              // fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  buildPostFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "type:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "appartment",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Bedrooms:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  bedrooms,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Bathrooms:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  bathrooms,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "parking:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  parking,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "wi-fi:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  internet,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Rent per month:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  rent,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "location:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Phone:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(height: 700),
            Stack(
              children: [
                Container(
                  height: 340,
                  color: Colors.black,
                ),
                buildPostImage(),
              ],
            ),
            Positioned(
              top: 250,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildPostHeader(),
                      buildPostFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
