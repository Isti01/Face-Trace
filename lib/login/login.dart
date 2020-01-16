import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/register_bloc/register_bloc.dart';
import 'package:face_app/bloc/register_bloc/register_bloc_states.dart';
import 'package:face_app/login/choose_face/choose_face.dart';
import 'package:face_app/login/login_email/login_email.dart';
import 'package:face_app/login/login_theme.dart';
import 'package:face_app/login/register_form/register_form.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  final int startPage;
  final FirebaseUser initialUser;
  const Login({
    Key key,
    this.startPage = 0,
    this.initialUser,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<DynamicGradientBackgroundState> _backgroundKey =
      GlobalKey(debugLabel: "_backgroundKey");
  PageController controller;
  FirebaseUser user;
  AppColor initialColor;
  final RegisterBloc bloc = RegisterBloc();

  @override
  void initState() {
    super.initState();
    initialColor = bloc.state.color;
    user = widget.initialUser;
    controller = PageController(initialPage: widget.startPage);
  }

  List<Widget> pages(BuildContext context, RegisterState state) => [
        LoginEmail(
          onLoginCompleted: () => onLoginCompleted(context),
          color: state.color,
        ),
        RegisterForm(
          user: user,
          backgroundKey: _backgroundKey,
          bloc: bloc,
          onRegistrationFinished: (List<Face> faces) async {
            if (faces.length == 1) {
              // did it this way, because state mapping is async and I cannot await it

              await saveUserData(user, state.update(userFace: faces.first));
              return;
            }
            nextPage();
          },
        ),
        ChooseFace(
          faces: state.detectedFaces,
          initialFace: state.userFace,
          onFaceChosen: bloc.onFaceChosen,
          faceImagePath: state.facePhoto,
          color: state.color,
          onFinished: () => saveUserData(user, state),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: loginTheme,
      child: BlocBuilder<RegisterBloc, RegisterState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            body: DynamicGradientBackground(
              key: _backgroundKey,
              color: initialColor,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: controller,
                children: pages(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  onLoginCompleted(BuildContext context) async {
    DocumentSnapshot document;
    user = await auth.currentUser();

    try {
      document = await getUserData(user);
    } catch (e, s) {
      print([e, s]);
    }
    if (document?.data != null && document.data.isNotEmpty) return;

    if (mounted) this.setState(() {});

    final name = user.displayName;

    if (name != null && name.isNotEmpty) nextPage();
    bloc.nameChanged(name);
  }

  nextPage() {
    return Future.delayed(Duration(milliseconds: 250), () async {
      await controller.nextPage(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    bloc.close();
    controller.dispose();
    super.dispose();
  }
}
