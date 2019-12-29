import 'package:face_app/bloc/match_bloc.dart';
import 'package:face_app/bloc/match_bloc_states.dart';
import 'package:face_app/home/match_page/match_card_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({Key key}) : super(key: key);

  MatchBloc bloc(BuildContext context) => BlocProvider.of<MatchBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) => MatchCardStack(
        state: state,
        onSwiped: bloc(context).onSwiped,
      ),
    );
  }
}
