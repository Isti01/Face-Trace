import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/util/firestore_queries.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String uid;

  const ProfileCard({Key key, this.uid}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Future<DocumentSnapshot> future;

  @override
  void initState() {
    future = firestore.collection('users').document(widget.uid).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final data = (snapshot.data as DocumentSnapshot).data;
        return ListTile(
          leading: CircleAvatar(
            child: Image.network(data['profileImage']),
          ),
          title: Text(data['name']),
          subtitle: Text(data['description']),
        );
      },
    );
  }
}
