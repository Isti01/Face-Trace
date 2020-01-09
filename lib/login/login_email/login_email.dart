import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/login_logic.dart';
import 'package:face_app/login/login_email/forgot_password_form.dart';
import 'package:face_app/util/app_toast.dart';
import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

import 'login_email_form_base.dart';
import 'login_tabbar.dart';

class LoginEmail extends StatefulWidget {
  final Function() onLoginCompleted;
  final AppColor color;

  const LoginEmail({
    Key key,
    @required this.onLoginCompleted,
    this.color,
  }) : super(key: key);

  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        LoginTabBar(controller: controller),
        SizedBox(height: 4),
        SizedBox(
          height: 400,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  EmailForm(
                    key: PageStorageKey("Email login form"),
                    onLoginCompleted: widget.onLoginCompleted,
                    color: widget.color,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: AppBorderRadius,
                          onTap: () {
                            Scaffold.of(context).showBottomSheet(
                              (c) => ForgotPasswordForm(color: widget.color),
                              elevation: 8,
                              backgroundColor: Colors.white,
                              shape: AppBorder,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: Text('Elfelejtette jelszavát?'),
                          ),
                        )),
                  ),
                ],
              ),
              EmailForm(
                key: PageStorageKey("Email register form"),
                register: true,
                onLoginCompleted: widget.onLoginCompleted,
                color: widget.color,
              ),
            ],
          ),
        ),
        Text(
          'Vagy',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              shape: AppBorder,
              color: Colors.white,
              onPressed: () async {
                if (await logInWithGoogle())
                  widget.onLoginCompleted();
                else
                  showToast(context, title: "A bejelentkezés sikertelen");
              },
              icon: Image.asset('assets/google.png', height: 24, width: 24),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Belépés Google-el'),
              ),
              textColor: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
