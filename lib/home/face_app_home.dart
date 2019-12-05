import 'package:face_app/home/profile_card.dart';
import 'package:face_app/util/firestore_queries.dart';
import 'package:flutter/material.dart';

class FaceAppHome extends StatefulWidget {
  @override
  _FaceAppHomeState createState() => _FaceAppHomeState();
}

class _FaceAppHomeState extends State<FaceAppHome> {
  var future;

  @override
  void initState() {
    super.initState();

    future = getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final list = snapshot.data ?? [];

          return ListView.builder(
            itemBuilder: (c, i) => ProfileCard(uid: list[i]),
            itemCount: list.length,
          );
        },
      ),
    );
  }
}
