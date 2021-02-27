import 'package:flutter/material.dart';
import 'package:homie_app/widgets/post.dart';

class PostTile extends StatefulWidget {
  final Post post;
  PostTile(this.post);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(child: Image.network(widget.post.mediaUrl)),
    );
  }
}
