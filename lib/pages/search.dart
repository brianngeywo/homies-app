import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homie_app/pages/home.dart';
import 'package:homie_app/pages/post_screen.dart';
import 'package:homie_app/pages/profile.dart';
import 'package:homie_app/widgets/post.dart';
import 'package:homie_app/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> postResultsFuture;
  handleSearch(String query) {
    Future<QuerySnapshot> houses = timelineRef
        .where(
          "location",
          isGreaterThanOrEqualTo: query,
        )
        .where(
          "location",
          isLessThan: query + 'z',
        )
        .get();
    setState(() {
      postResultsFuture = houses;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "location e.g ruaka...",
          filled: true,
          prefixIcon: Icon(
            Icons.home,
            size: 28,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              clearSearch();
            },
          ),
        ),
        onChanged: handleSearch,
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              "assets/images/search.svg",
              height: 300,
              width: double.infinity,
            ),
            Text(
              "Find rentals...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildpostResults() {
    return FutureBuilder(
      future: postResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<PostResult> postResults = [];
        snapshot.data.docs.forEach(
          (postDocSnap) {
            Post post = Post.fromDocument(postDocSnap);
            PostResult postResult = PostResult(post);
            postResults.add(postResult);
          },
        );
        return ListView(
          children: postResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body: postResultsFuture == null ? buildNoContent() : buildpostResults(),
    );
  }
}

class PostResult extends StatelessWidget {
  final Post post;
  PostResult(this.post);
  showFullPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PostScreen(postId: post.postId, userId: post.ownerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withBlue(100),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showFullPost(context),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(post.mediaUrl),
              ),
              title: Text(post.description,
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profile(
        profileId: profileId,
      ),
    ),
  );
}
