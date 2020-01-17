import 'dart:async';

import 'package:face_app/bloc/firebase/download_image.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/register_bloc/register_bloc.dart';
import 'package:face_app/bloc/register_bloc/register_bloc_states.dart';
import 'package:face_app/login/register_form/pages/get_pages.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:face_app/util/page_indicator.dart';
import 'package:face_app/util/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const WaitDuration = Duration(milliseconds: 150);
const PageSwitchDuration = Duration(milliseconds: 1250);
const SwitchCurve = Curves.easeInOutCubic;

class RegisterForm extends StatefulWidget {
  final RegisterBloc bloc;
  final FirebaseUser user;
  final GlobalKey<DynamicGradientBackgroundState> backgroundKey;
  final Function(List<Face> face) onRegistrationFinished;
  final Function() onBack;

  const RegisterForm({
    Key key,
    this.user,
    this.backgroundKey,
    this.bloc,
    @required this.onRegistrationFinished,
    this.onBack,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final PageController controller = PageController();
  bool hasName = false;
  StreamSubscription subscription;

  _delayed(func) {
    FocusScope.of(context).unfocus();

    Future.delayed(WaitDuration, () async {
      await func();
      this.setState(() {});
    });
  }

  jumpToPage(int index) => _delayed(() => controller.animateToPage(index,
      duration: PageSwitchDuration, curve: SwitchCurve));

  nextPage() => _delayed(() =>
      controller.nextPage(duration: PageSwitchDuration, curve: SwitchCurve));

  prevPage() => _delayed(() => controller.previousPage(
      duration: PageSwitchDuration, curve: SwitchCurve));

  _getUserPhoto([RegisterForm old]) async {
    final image = widget.user?.photoUrl;
    if (image == null) return;

    if (old != null && old.user.photoUrl == image) return;

    final path = await downloadImage(image);
    if (path == null) return;

    widget?.bloc?.updatePhoto(path);
  }

  @override
  void initState() {
    final name = widget?.user?.displayName;
    this.hasName = name != null && name.isNotEmpty;
    subscription = widget.bloc.listen((_) => setState(() {}));
    controller.addListener(() {
      setState(() {});
    });
    _getUserPhoto();
    super.initState();
  }

  @override
  void didUpdateWidget(RegisterForm oldWidget) {
    _getUserPhoto(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final children = getPages(
          context,
          state,
          widget.user,
          widget.bloc,
          nextPage,
          widget.backgroundKey,
          widget.onRegistrationFinished,
        );
        final pageCount = children.length;

        return Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: controller,
              children: children,
            ),
            PageSwitcher(
              pageIndex: controller.hasClients ? controller.page : 0,
              numPages: pageCount,
              onUp: prevPage,
              onDown: nextPage,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              top: 0,
              child: PageIndicator(
                controller: controller,
                numPages: pageCount,
                jumpToPage: jumpToPage,
              ),
            ),
            if (widget.onBack != null)
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () async {
                        await signOut();
                        widget.onBack();
                      },
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller?.dispose();
    super.dispose();
  }
}
