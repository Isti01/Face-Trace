import 'package:face_app/bloc/app_bloc.dart';
import 'package:face_app/bloc/chat_bloc.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/home/chat/chats_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FaceAppHome extends StatefulWidget {
  final AppColor appColor;
  final FirebaseUser user;

  const FaceAppHome({
    Key key,
    this.appColor,
    this.user,
  }) : super(key: key);

  @override
  _FaceAppHomeState createState() => _FaceAppHomeState();
}

class _FaceAppHomeState extends State<FaceAppHome> {
  int pageIndex = 0;
  AppBloc appBloc;
  ChatBloc chatBloc;
  @override
  void initState() {
    appBloc = AppBloc(color: widget.appColor);
    chatBloc = ChatBloc(user: widget.user, appBloc: appBloc);
    super.initState();
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
              child: ChatsPage(
                bloc: chatBloc,
              ),
              /*child: BlocBuilder<AppBloc, AppState>(
                bloc: bloc,
                builder: (context, state) => MatchCard(
                  loading: state.loadingUserList,
                  users: state.users,
                  uids: state.uidList,
                  onSwiped: (right, uid, index) {
                    final uids = state.uidList;
                    uids
                        .getRange(index, math.min(index + 3, uids.length))
                        .forEach(bloc.loadUser);

                    firestore.swipeUser(uid: uid, right: right);
                  },
                ),
              ),*/
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatBloc?.close();
    appBloc?.close();
    super.dispose();
  }
}
