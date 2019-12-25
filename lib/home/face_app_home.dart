import 'package:face_app/bloc/app_bloc.dart';
import 'package:face_app/bloc/chat_bloc.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/home/chat/chats_page.dart';
import 'package:face_app/home/match_card/match_page.dart';
import 'package:face_app/home/nav_bar/nav_bar.dart';
import 'package:face_app/util/constants.dart';
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
  PageController _controller;

  int pageIndex = 0;
  AppBloc appBloc;
  ChatBloc chatBloc;

  @override
  void initState() {
    _initBlocs();
    _controller = PageController();
    super.initState();
  }

  _initBlocs() {
    appBloc = AppBloc(color: widget.appColor);
    chatBloc = ChatBloc(user: widget.user, appBloc: appBloc);
  }

  _onItemTapped(int i) => setState(() {
        _controller.animateToPage(
          pageIndex = i,
          duration: Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      });

  @override
  void didUpdateWidget(FaceAppHome oldWidget) {
    if (oldWidget.user.uid != widget.user.uid) _initBlocs();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          NavBar(
            appColor: widget.appColor,
            onItemTapped: _onItemTapped,
            pageIndex: pageIndex,
          ),
          Flexible(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                MatchPage(appBloc: appBloc),
                ChatsPage(bloc: chatBloc),
                Center(
                  child: RaisedButton(
                      child: Text('kijelentkezes'),
                      onPressed: () {
                        auth.signOut();
                      }),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    chatBloc?.close();
    appBloc?.close();
    super.dispose();
  }
}
