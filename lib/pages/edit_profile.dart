import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:homie_app/models/User.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  User user;
  bool isLoading = false;
  bool _displayNameValid = true;
  getUser() async {
    user = User();
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot userDocSnap =
        await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(userDocSnap);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // // TODO: implement initState
    super.initState();
    getUser();
  }

  Column buildDiasplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            user.displayName,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "change your display name",
            errorText: _displayNameValid ? null : "name too short",
          ),
        )
      ],
    );
  }

  Column buildbioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            user.bio,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "update bio",
          ),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
    });
    if (_displayNameValid) {
      usersRef.doc(widget.currentUserId).update({
        "bio": bioController.text,
        "display name": displayNameController.text,
      });
      SnackBar snackBar = SnackBar(content: Text("profile updated!!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900].withBlue(110),
        title: Text(
          "Edit Profile",
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Center(
                        child: Card(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(user.photoUrl)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildDiasplayNameField(),
                            buildbioField(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: updateProfileData,
                        child: Card(
                          elevation: 10,
                          child: Container(
                            height: 50,
                            width: 180,
                            color: Colors.blueGrey[900].withBlue(110),
                            child: Center(
                              child: Text(
                                "Update Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
