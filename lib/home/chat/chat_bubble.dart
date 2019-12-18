import 'package:face_app/bloc/data_classes/chat_message.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool includeName;
  const ChatBubble({
    Key key,
    @required this.message,
    this.includeName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.3, horizontal: 12),
      child: Column(
        crossAxisAlignment: message.gotFromOther
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (includeName) ...[
            SizedBox(height: 8),
            Text(
              message.createdBy,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 10),
            ),
          ],
          ConstrainedBox(
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message.message,
                  textAlign:
                      message.gotFromOther ? TextAlign.start : TextAlign.end,
                  style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white,
                      ),
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
