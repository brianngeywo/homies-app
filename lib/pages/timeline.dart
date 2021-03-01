import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homie_app/models/User.dart';
import 'package:homie_app/pages/search.dart';
import 'package:homie_app/widgets/header.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/widgets/post.dart';
import 'package:homie_app/widgets/progress.dart';

class Timeline extends StatefulWidget {
  final User currentUser;
  Timeline({this.currentUser});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline>
    with AutomaticKeepAliveClientMixin<Timeline> {
  List<Post> timelinePosts = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot timelineDocSnap =
        await timelineRef.orderBy("timestamp", descending: true).get();

    List<Post> timelinePosts = timelineDocSnap.docs
        .map((timelineDocSnap) => Post.fromDocument(timelineDocSnap))
        .toList();
    setState(() {
      this.timelinePosts = timelinePosts;
    });
  }

  buildTimeline() {
    if (timelinePosts == null) {
      return circularProgress();
    } else if (timelinePosts.isEmpty) {
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
      return Stack(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 5),
            child: ListView(
              children: timelinePosts,
            ),
          ),
          // Container(
          //   height: 50,
          //   margin: EdgeInsets.symmetric(
          //               vertical: 8,
          //             ),
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       Card(
          //         elevation: 6,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Container(
          //             margin: EdgeInsets.symmetric(
          //               vertical: 8,
          //               horizontal: 10,
          //             ),
          //             child: Center(child: Text("categories"))),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      );
    }
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => showProfile(context, profileId: currentUser.id),
                      child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: CircleAvatar(
                radius: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(currentUser.photoUrl),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        child: buildTimeline(),
        onRefresh: () => getTimeline(),
      ),
    );
  }
}
