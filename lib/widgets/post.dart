import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homie_app/models/User.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/pages/post_screen.dart';
import 'package:homie_app/pages/search.dart';
import 'package:homie_app/widgets/progress.dart';
// import 'package:homie_app/pages/profile.dart';

class Post extends StatefulWidget {
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

  Post({
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
  factory Post.fromDocument(DocumentSnapshot postDocSnap) {
    return Post(
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
  _PostState createState() => _PostState(
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

class _PostState extends State<Post> {
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
  _PostState({
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
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return GestureDetector(
            onTap: () => showProfile(context, profileId: widget.ownerId),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              title: GestureDetector(child: Text(user.displayName)),
              subtitle: Text(location),
            ),
          );
        });
  }

  buildPostImage() {
    return GestureDetector(
      onTap: () => showFullPost(context),
      child: Container(
        color: Colors.grey[200],
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 180),
          child: Image.network(
            mediaUrl,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(postId: postId, userId: ownerId),
      ),
    );
  }

  showFullPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(postId: postId, userId: ownerId),
      ),
    );
  }

  buildPostFooter(context) {
    return GestureDetector(
      onTap: () => showFullPost(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "Kshs $rent/month",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.king_bed,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(width: 5),
                        Text(
                          bedrooms,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        
                        Icon(
                          Icons.bathtub_sharp,
                          color: Colors.black,
                          size: 23,
                        ),
                        SizedBox(width: 5),
                        Text(
                          bathrooms,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(width: 5),
                        Text(
                          parking,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wifi,
                          color: Colors.black,
                          size: 23,
                        ),
                        SizedBox(width: 3),
                        Text(
                          internet,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPostHeader(),
            buildPostImage(),
            buildPostFooter(context),
          ],
        ),
      ),
    );
  }
}
