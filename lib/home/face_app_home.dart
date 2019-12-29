import 'package:face_app/bloc/chat_bloc.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/match_bloc.dart';
import 'package:face_app/home/chat/chats_page.dart';
import 'package:face_app/home/match_page/match_page.dart';
import 'package:face_app/home/nav_bar/nav_bar.dart';
import 'package:face_app/home/user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaceAppHome extends StatefulWidget {
  /// I need the user as a parameter, because in order to access it I need context,
  /// which I don't have in the initState
  final FirebaseUser user;
  final AppColor appColor;
  const FaceAppHome({Key key, this.user, this.appColor}) : super(key: key);

  @override
  _FaceAppHomeState createState() => _FaceAppHomeState();
}

class _FaceAppHomeState extends State<FaceAppHome> {
  PageController _controller;

  int pageIndex = 0;
  MatchBloc matchBloc;
  ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    _initBlocs();
    _controller = PageController();
  }

  _initBlocs() {
    matchBloc = MatchBloc();
    chatBloc = ChatBloc(user: widget.user, matchBloc: matchBloc);
  }

  _onItemTapped(int i) {
    FocusScope.of(context).unfocus();
    setState(() {
      _controller.animateToPage(
        pageIndex = i,
        duration: Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    });
  }

  @override
  void didUpdateWidget(FaceAppHome oldWidget) {
    if (oldWidget.user.uid != widget.user.uid) _initBlocs();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: matchBloc,
      child: BlocProvider.value(
        value: chatBloc,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                NavBar(onItemTapped: _onItemTapped, pageIndex: pageIndex),
                Flexible(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: [
                      MatchPage(key: PageStorageKey('discover page')),
                      ChatsPage(key: PageStorageKey('chat page')),
                      UserPage(key: PageStorageKey('user page')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    chatBloc?.close();
    matchBloc?.close();
    super.dispose();
  }
}
