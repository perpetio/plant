import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key key}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.hasData) {
          QueryDocumentSnapshot user;
          snapshot.data.docs.map((element) {
            if (element['uid'] == FirebaseAuth.instance.currentUser.uid) {
              user = element;
            }
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundImage: user['image'] == ''
                  ? AssetImage('assets/images/profile')
                  : NetworkImage(user['image']),
            ),
          );
        } else {
          return Center();
        }
      },
    );
  }
}
