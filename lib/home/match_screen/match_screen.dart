import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:flutter/material.dart';

class MatchScreen extends StatelessWidget {
  final User partnerData;
  final VoidCallback openChat;

  const MatchScreen({
    Key key,
    this.partnerData,
    this.openChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = CurrentUser.of(context).user;
    final size = MediaQuery.of(context).size;

    final textTheme = Theme.of(context).textTheme.apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
    return Scaffold(
      body: AnimatedTheme(
        data: ThemeData(
          primarySwatch: user.appColor.color,
          textTheme: textTheme,
        ),
        child: DynamicGradientBackground(
          color: user.appColor,
          child: Material(
            type: MaterialType.transparency,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: _body(textTheme, size)),
                  Positioned(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(TextTheme textTheme, Size size) => Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🎉 Egymásra találtatok! 🎉",
                style: textTheme.headline,
              ),
              SizedBox(height: 8),
              Text(
                "Te és ${partnerData.name} kedvelitek egymást! 💕",
                style: textTheme.subtitle,
              ),
              SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints.loose(
                  Size(double.infinity, size.height * 0.4),
                ),
                child: Image.network(partnerData.profileImage),
              ),
              SizedBox(height: 24),
              if (openChat != null)
                OutlineButton(
                  child: Text('Küldj üzenetet!', style: textTheme.title),
                  onPressed: () => throw UnimplementedError('open chat'),
                  color: Colors.white,
                  borderSide: BorderSide(color: Colors.white),
                  textColor: Colors.white,
                  shape: AppBorder,
                ),
            ],
          ),
        ),
      );
}
