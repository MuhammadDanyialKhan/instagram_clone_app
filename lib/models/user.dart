import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String userName;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  User({
    this.displayName,
    this.email,
    this.photoUrl,
    this.id,
    this.userName,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot documentSnapshot) {
    return User(
      id: documentSnapshot['id'],
      email: documentSnapshot['email'],
      userName: documentSnapshot['username'],
      bio: documentSnapshot['bio'],
      displayName: documentSnapshot['displayName'],
      photoUrl: documentSnapshot['photoUrl'],
    );
  }
}
