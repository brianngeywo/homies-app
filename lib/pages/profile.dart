import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homie_app/models/User.dart';
import 'package:homie_app/pages/edit_profile.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/pages/post_screen.dart';
import 'package:homie_app/widgets/header.dart';
import 'package:homie_app/widgets/post.dart';
import 'package:homie_app/widgets/profile_header.dart';
import 'package:homie_app/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  String postOrientation = "list";
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];
  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot postDocSnap = await postsRef
        .doc(widget.profileId)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = postDocSnap.docs.length;
      posts = postDocSnap.docs
          .map((postDocSnap) => Post.fromDocument(postDocSnap))
          .toList();
    });
  }

  // showPost(context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           PostScreen(userId: widget.profileId),
  //     ),
  //   );
  // }
  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
        color: Theme.of(context).accentColor.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/no_content.svg",
              height: 260.9,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "No Posts",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else {
      if (postOrientation == "list") {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white),
          child: Column(
            children: posts,
          ),
        );
      }
      // else if (postOrientation == "grid") {
      //   List<GridTile> gridTiles = [];
      //   posts.forEach((post) {
      //     gridTiles.add(GridTile(child: PostTile(post)));
      //     return GridView.count(
      //       crossAxisCount: 3,
      //       childAspectRatio: 1.0,
      //       mainAxisSpacing: 1.5,
      //       crossAxisSpacing: 1.5,
      //       shrinkWrap: true,
      //       physics: NeverScrollableScrollPhysics(),
      //       children: gridTiles,
      //     );
      //   });
      // }
    }
  }

  final String currentUserId = currentUser?.id;
  buildProfileButton() {
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(text: "Edit Profile", function: editProfile);
    } else {
      return buildCountColumn("Rentals listed:", postCount);
    }
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
  }

  Container buildButton({String text, Function function}) {
    return Container(
      child: GestureDetector(
        onTap: function,
        child: Card(
          color: Colors.blueAccent[200],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            height: 45,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                wordSpacing: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildCountColumn(String label, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              wordSpacing: 4,
              
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);

          return Container(
            color: Colors.blueGrey[900].withBlue(110),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(height: 15),
                  Text(
                    user.displayName,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 15),

                  Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.blueAccent,
                                child: Icon(
                                  Icons.phone,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("0798767470",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.blueAccent,
                                child: Icon(
                                  Icons.mail,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(user.email,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // buildCountColumn("Rentals:", postCount),
                  buildProfileButton(),
                ],
              ),
            ),
          );
        });
  }

  // buildTogglePostsOrientation() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       IconButton(
  //         icon: Icon(
  //           Icons.grid_on,
  //           color: postOrientation == "grid"
  //               ? Theme.of(context).primaryColor
  //               : Colors.grey,
  //         ),
  //         onPressed: () => setPostOrientation("grid"),
  //       ),
  //       IconButton(
  //         icon: Icon(
  //           Icons.list,
  //           color: postOrientation == "list"
  //               ? Theme.of(context).primaryColor
  //               : Colors.grey,
  //         ),
  //         onPressed: () => setPostOrientation("list"),
  //       ),
  //     ],
  //   );
  // }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: profileHeader(context, isAppTitle: true),
      backgroundColor: Colors.blueGrey[900].withBlue(110),
      body: ListView(
        children: [
          buildProfileHeader(),
          buildProfilePosts(),
        ],
      ),
    );
  }
}
