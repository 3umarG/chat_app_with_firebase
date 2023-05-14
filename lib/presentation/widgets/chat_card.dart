import 'package:chat_app/core/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/chat_user.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key, required this.user}) : super(key: key);

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: mediaQuery(context).width * .01 , vertical: 4),
      child:  ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title:  Text(user.name ?? "Name"),
        subtitle:  Text(user.about ?? "About"),
        trailing:  Text(user.lastActive ?? "7:00 AM"),
        leading:  const CircleAvatar(
          child:  Icon(CupertinoIcons.person_2_alt),
        ),
      ),
    );
  }
}
