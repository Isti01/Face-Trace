import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/login_logic.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/login_email/login_email_form.dart';
import 'package:face_app/util/app_toast.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/gradient_raised_button.dart';
import 'package:flutter/material.dart';

class EmailForm extends StatefulWidget {
  final bool register;
  final Function() onLoginCompleted;
  final AppColor color;

  const EmailForm({
    Key key,
    this.register = false,
    @required this.onLoginCompleted,
    @required this.color,
  }) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'email form');
  TextEditingController emailController, passController, passAgainController;

  bool get isFormValid => _formKey.currentState.validate();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
    passAgainController = TextEditingController();
  }

  onSubmitted(String email, String pass, String passAgain) async {
    final localizations = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    if (isFormValid) {
      bool successful;

      final onFailed = (error) => showToast(context,
          title: widget.register
              ? localizations.registerFailed
              : localizations.signInFailed,
          message: error);

      if (widget.register)
        successful = await register(context, email, pass, onFailed);
      else
        successful = await logIn(context, email, pass, onFailed);

      if (successful) widget.onLoginCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 8,
                  color: Colors.white,
                  borderRadius: AppBorderRadius,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Theme(
                      data: ThemeData(primarySwatch: widget.color.color),
                      child: LoginEmailForm(
                        formKey: _formKey,
                        register: widget.register,
                        emailController: emailController,
                        passAgainController: passAgainController,
                        passController: passController,
                        onFormSubmitted: onSubmitted,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28),
              ],
            ),
            Positioned(
              bottom: 0,
              child: GradientRaisedButton(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Text(
                    widget.register
                        ? localizations.register
                        : localizations.signIn,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                gradient: LinearGradient(colors: widget.color.next.colors),
                onTap: () => onSubmitted(
                  emailController.text,
                  passController.text,
                  passAgainController.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    passAgainController.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
