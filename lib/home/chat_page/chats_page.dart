import 'package:face_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:face_app/home/chat_page/search_box.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(canvasColor: Colors.white),
      child: Padding(
        padding: PagePadding,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height / 5,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).chat,
                    style: theme.textTheme.display1.apply(color: Colors.white),
                  ),
                ),
              ),
            ),
            SearchBox(bloc: BlocProvider.of<ChatBloc>(context)),
            SliverFillRemaining(
              child: Material(color: Colors.white),
              fillOverscroll: true,
              hasScrollBody: false,
            ),
          ],
        ),
      ),
    );
  }
}
