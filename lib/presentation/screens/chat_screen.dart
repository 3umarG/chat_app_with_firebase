import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/media_query.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildChatScreenAppBar(context),
    );
  }

  _buildCircleAvatar(BuildContext context) {
    return user.image != null
        ? ClipRRect(
            borderRadius:
                BorderRadius.circular(mediaQuery(context).height * 0.3),
            child: CachedNetworkImage(
              width: mediaQuery(context).height * 0.05,
              height: mediaQuery(context).height * 0.05,
              imageUrl: user.image!,
              placeholder: (_, s) => const CircleAvatar(
                child: Icon(CupertinoIcons.person_2_alt),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person_2_alt),
              ),
            ),
          )
        : const CircleAvatar(
            child: Icon(CupertinoIcons.person_2_alt),
          );
  }

  _buildChatScreenAppBar(BuildContext context) => AppBar(
        title: Row(
          children: [
            _buildCircleAvatar(context),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name!,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  "Last Seen not available",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
