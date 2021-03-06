import 'package:face_app/bloc/match_bloc/match_bloc.dart';
import 'package:face_app/bloc/match_bloc/match_bloc_states.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/home/match_page/match_card.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final nullUsers = List.generate(NumDisplayedUsers, (_) => null);

class MatchPage extends StatelessWidget {
  const MatchPage({Key key}) : super(key: key);

  MatchBloc bloc(BuildContext context) => BlocProvider.of<MatchBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(builder: (context, state) {
      if (state.loadingUserList) return _body(context, nullUsers, state);

      final uids = state.uidList;

      return _body(context, uids.take(NumDisplayedUsers).toList(), state);
    });
  }

  Widget _body(context, List<String> uids, MatchState state) {
    final localizations = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final length = uids.length;

    return Column(
      children: <Widget>[
        Padding(
          padding: PagePadding,
          child: SizedBox(
            height: size.height / 5,
            child: Row(
              children: <Widget>[
                Text(
                  localizations.discover,
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .apply(color: Colors.white),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () =>
                      BlocProvider.of<MatchBloc>(context).getUsers(),
                ),
              ],
            ),
          ),
        ),
        if (uids?.isEmpty ?? true)
          _ranOut(context, localizations)
        else
          Stack(
            children: [
              for (int i = length - 1; i >= 0; i--)
                _matchCard(context, i, uids[i], state)
            ],
          ),
      ],
    );
  }

  Widget _matchCard(BuildContext context, int i, uid, MatchState state) =>
      MatchCard(
        key: uid == null ? null : ValueKey(uid),
        place: i,
        uid: uid,
        user: state.users[uid],
        onSwiped: (right, uid) => bloc(context).onSwiped(right, uid),
      );

  Widget _ranOut(context, AppLocalizations localizations) => Expanded(
        child: Center(
          child: Text(
            localizations.noMoreCards,
            style:
                Theme.of(context).textTheme.display1.apply(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
