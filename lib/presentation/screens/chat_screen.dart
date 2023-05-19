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
      body: Column(
        children: [
          _buildTypeBar(context),
        ],
      ),
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

  _buildTypeBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mediaQuery(context).height * 0.01 , horizontal: mediaQuery(context).width * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  _buildIconForTypeBar(Icons.emoji_emotions),
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Colors.blueAccent,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type something ...",
                          hintStyle: TextStyle(
                            color: Colors.blueAccent,
                          )),
                    ),
                  ),
                  _buildIconForTypeBar(Icons.image),
                  _buildIconForTypeBar(Icons.camera_alt),
                ],
              ),
            ),
          ),
          MaterialButton(
            color: Colors.green,
            minWidth: 5,
            padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.send_outlined , color: Colors.white,size: 28),
          ),
        ],
      ),
    );
  }

  _buildIconForTypeBar(IconData icon) => IconButton(
        onPressed: () {},
        icon: Icon(
          icon,
          color: Colors.blueAccent,
        ),
      );
}
