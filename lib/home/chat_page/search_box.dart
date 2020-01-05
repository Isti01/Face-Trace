import 'package:face_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:face_app/bloc/chat_bloc/chat_bloc_states.dart';
import 'package:face_app/home/chat_page/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class SearchBox extends StatefulWidget {
  final bloc;

  const SearchBox({Key key, this.bloc}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.bloc.state.filter ?? '');
    _controller.addListener(
      () => widget.bloc.searchSubject.add(_controller.text),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return SliverStickyHeader(
          overlapsContent: false,
          header: _textField,
          sliver: state.loadingChats ? _loading : ChatList(state: state),
        );
      },
    );
  }

  Widget get _textField => SafeArea(
        child: Material(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    },
                    highlightColor: Colors.transparent,
                  ),
                  filled: true,
                  hintText: 'Keresés',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.zero),
              controller: _controller,
            ),
          ),
        ),
      );

  Widget get _loading => SliverToBoxAdapter(
        child: Material(
          child: SizedBox(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
