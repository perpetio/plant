import 'package:flutter/material.dart';

class UserData {
  String uid;
  String name;
  String email;
  String imageUrl;

  UserData({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        imageUrl: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'image': imageUrl,
      };
}
