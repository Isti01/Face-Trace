import 'package:face_app/home/match_card/match_card.dart';
import 'package:face_app/util/firestore_queries.dart';
import 'package:flutter/material.dart';

class FaceAppHome extends StatefulWidget {
  @override
  _FaceAppHomeState createState() => _FaceAppHomeState();
}

class _FaceAppHomeState extends State<FaceAppHome> {
  var future;
  int pageIndex = 0;
  int index = 0;
  @override
  void initState() {
    super.initState();
    future = getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BottomNavigationBar(
              elevation: 0,
              currentIndex: pageIndex,
              onTap: (i) => setState(() => pageIndex = i),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: SizedBox(),
                  activeIcon: Icon(Icons.close),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.close),
                  icon: Icon(Icons.person),
                  title: SizedBox(),
                ),
              ],
            ),
            Flexible(
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final list = snapshot.data ?? [];

                  return MatchCard(
                    users: list,
                    onSwiped: (right, uid) => setState(() {
                      index++;
                      print('setState');
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
