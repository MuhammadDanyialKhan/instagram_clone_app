import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramcloneapp/models/user.dart';
import 'package:instagramcloneapp/pages/home.dart';
import 'package:instagramcloneapp/widgets/progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String userName;
  final String location;
  final String description;
  final String mediaUrl;
  final Map<String, bool> likes;

  Post({
    this.userName,
    this.postId,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.ownerId,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      description: doc['description'],
      ownerId: doc['ownerId'],
      userName: doc['userName'],
      location: doc['location'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    // if likes is equal to null
    if (likes == null) return 0;
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((like) {
      if (like == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
        description: this.description,
        location: this.location,
        mediaUrl: this.mediaUrl,
        userName: this.userName,
        likes: this.likes,
        ownerId: this.ownerId,
        postId: this.postId,
        likeCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String userName;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map<String, bool> likes;

  _PostState({
    this.userName,
    this.postId,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.ownerId,
    this.likeCount,
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print("Showing profile"),
            child: Text(
              user.userName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing: IconButton(
            onPressed: () => print("deleting post"),
            icon: Icon(Icons.more_vert),
          ),
        );
      },
    );
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => print("linking post"),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => print("liking post"),
              child: Icon(
                Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => print("Showing comments"),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$userName ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
