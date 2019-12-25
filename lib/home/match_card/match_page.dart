import 'dart:math' as math;

import 'package:face_app/bloc/app_bloc.dart';
import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/home/match_card/match_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchPage extends StatelessWidget {
  final AppBloc appBloc;

  const MatchPage({Key key, this.appBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      bloc: appBloc,
      builder: (context, state) => MatchCards(
        loading: state.loadingUserList,
        users: state.users,
        uids: state.uidList,
        appColor: state.color,
        onSwiped: (right, uid, index) {
          final uids = state.uidList;
          uids
              .getRange(index, math.min(index + 3, uids.length))
              .forEach(appBloc.loadUser);

          swipeUser(uid: uid, right: right);
        },
      ),
    );
  }
}
