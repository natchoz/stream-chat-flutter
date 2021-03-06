import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker_paint.png)
///
/// It shows a reaction picker
///
/// Usually you don't use this widget as it's one of the default widgets used by [MessageWidget.onMessageActions].
class ReactionPicker extends StatelessWidget {
  const ReactionPicker({
    Key key,
    @required this.reactionToEmoji,
    @required this.message,
    @required this.channel,
    this.size = 30,
  }) : super(key: key);

  final Map<String, String> reactionToEmoji;
  final Message message;
  final double size;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: reactionToEmoji.keys.map((reactionType) {
          var user = StreamChat.of(context).user;
          final ownReactionIndex = message.latestReactions?.indexWhere(
                  (reaction) =>
                      reaction.type == reactionType &&
                      reaction.userId == user.id) ??
              -1;
          final totalScore = message.latestReactions
              .where((r) => r.type == reactionType)
              .map((r) => r.score)
              .fold(0, (tot, s) => tot + s);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                iconSize: size,
                icon: Text(
                  reactionToEmoji[reactionType],
                  style: TextStyle(
                    fontSize: size - 10,
                  ),
                ),
                onPressed: () {
                  if (ownReactionIndex != -1) {
                    removeReaction(
                        context, message.latestReactions[ownReactionIndex]);
                  } else {
                    sendReaction(context, reactionType);
                  }
                },
              ),
              totalScore > 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        totalScore.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SizedBox(),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// Add a reaction to the message
  void sendReaction(BuildContext context, String reactionType) {
    channel.sendReaction(message, reactionType);
    Navigator.of(context).pop();
  }

  /// Remove a reaction from the message
  void removeReaction(BuildContext context, Reaction reaction) {
    channel.deleteReaction(message, reaction);
    Navigator.of(context).pop();
  }
}
