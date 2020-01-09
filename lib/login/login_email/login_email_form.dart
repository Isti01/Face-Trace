import 'package:face_app/bloc/login_logic.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/util/input_field.dart';
import 'package:flutter/material.dart';

class LoginEmailForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController,
      passController,
      passAgainController;
  final bool register;
  final emailErrorText, passErrorText, passAgainErrorText;
  final Function(String email, String pass, String passAgain) onFormSubmitted;

  const LoginEmailForm({
    Key key,
    @required this.formKey,
    @required this.emailController,
    @required this.passController,
    @required this.passAgainController,
    @required this.onFormSubmitted,
    this.register = false,
    this.emailErrorText,
    this.passErrorText,
    this.passAgainErrorText,
  }) : super(key: key);

  @override
  _LoginEmailFormState createState() => _LoginEmailFormState();
}

class _LoginEmailFormState extends State<LoginEmailForm> {
  FocusNode emailNode, passNode, passAgainNode;

  bool obscure = true;

  String get email => widget.emailController.text;

  String get pass => widget.passController.text;

  String get passAgain => widget.passAgainController.text;

  Widget get divider => Divider(
        height: 16,
        indent: 20,
        endIndent: 8,
      );

  @override
  void initState() {
    super.initState();

    emailNode = FocusNode();
    passNode = FocusNode();
    passAgainNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Form(
      onChanged: () => this.setState(() {}),
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputField(
            controller: widget.emailController,
            textInputAction: TextInputAction.next,
            labelText: localizations.emailAddress,
            icon: Icons.email,
            validator: (s) => validateEmail(context, s),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(passNode);
            },
          ),
          divider,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: InputField(
                  controller: widget.passController,
                  node: passNode,
                  obscureText: obscure,
                  labelText: localizations.password,
                  icon: Icons.lock,
                  validator: (val) =>
                      validatePasswordStrength(context, val, !widget.register),
                  textInputAction: widget.register
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onFieldSubmitted: widget.register
                      ? (_) {
                          FocusScope.of(context).requestFocus(passAgainNode);
                        }
                      : (_) {
                          FocusScope.of(context).unfocus();
                          widget.onFormSubmitted(email, pass, passAgain);
                        },
                ),
              ),
              IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ],
          ),
          if (widget.register) ...[
            divider,
            InputField(
              controller: widget.passAgainController,
              labelText: localizations.passwordAgain,
              node: passAgainNode,
              icon: Icons.lock,
              obscureText: obscure,
              validator: (_) => validatePasswords(context, pass, passAgain),
              onFieldSubmitted: (_) {
                FocusScope.of(context).unfocus();
                widget.onFormSubmitted(email, pass, passAgain);
              },
            ),
          ],
          SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailNode.dispose();
    passAgainNode.dispose();
    passNode.dispose();
    super.dispose();
  }
}
