import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String photoUrl;
  final String username;
  final String bio;
  final String displayName;
  User({
    this.bio,
    this.email,
    this.id,
    this.photoUrl,
    this.username,
    this.displayName,
  });

  factory User.fromDocument(DocumentSnapshot userDocSnap) {
    return User(
      id: userDocSnap['id'],
      email: userDocSnap['email'],
      bio: userDocSnap['bio'],
      photoUrl: userDocSnap['photoUrl'],
      displayName: userDocSnap['display name'],
    );
  }
}
