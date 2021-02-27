import 'package:flutter/material.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/widgets/full_post.dart';
import 'package:homie_app/widgets/header.dart';
import 'package:homie_app/widgets/progress.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;
  PostScreen({this.postId, this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.doc(userId).collection("userPosts").doc(postId).get(),
      builder:
          (context, postDocSnap) {
        if (!postDocSnap.hasData) {
          return circularProgress();
        } else {
          FullPost post = FullPost.fromDocument(postDocSnap.data);
          return Center(
            child: Scaffold(
              appBar: header(context, titleText: post.description),
              body: ListView(
                children: [
                  Container(child: post),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
