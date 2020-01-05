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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.3, horizontal: 12),
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
                fontSize: 10,
                color: Colors.white54,
              ),
            ),
          ],
          ConstrainedBox(
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: fromOther
                  ? Colors.white30
                  : user.appColor.color[300].withAlpha(80),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message.message,
                  textAlign: fromOther ? TextAlign.start : TextAlign.end,
                  style: textTheme.body2.copyWith(color: Colors.white),
                ),
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
}
