import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool includeName;
  final User partner;

  const ChatBubble({
    Key key,
    @required this.message,
    this.includeName = false,
    this.partner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final user = CurrentUser.of(context).user;

    final fromOther = message.gotFromOther;

    final double verticalPadding = message.type == MessageType.text ? 0.3 : 2;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 12),
      child: Column(
        crossAxisAlignment:
            fromOther ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (includeName && fromOther && partner.name != null) ...[
            SizedBox(height: 8),
            Text(
              partner.name,
              style: textTheme.body1.copyWith(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
          ConstrainedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: fromOther
                    ? Colors.white30
                    : user.appColor.color[300].withAlpha(80),
                child: _content(context, textTheme),
              ),
            ),
            constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: double.infinity,
              maxWidth: size * 0.65,
              minWidth: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, TextTheme textTheme) =>
      message.type == MessageType.text
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message.message,
                textAlign:
                    message.gotFromOther ? TextAlign.start : TextAlign.end,
                style: textTheme.body2.copyWith(color: Colors.white),
              ),
            )
          : Image.network(
              message.message,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, e) => AnimatedCrossFade(
                  key: ValueKey(message.message),
                  firstChild: child,
                  secondChild: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Icon(
                      Icons.image,
                      color: Colors.white70,
                      size: 46,
                    ),
                  ),
                  crossFadeState: e == null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 250)),
            );
}
