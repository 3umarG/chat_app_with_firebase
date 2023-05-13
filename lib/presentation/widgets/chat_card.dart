import 'package:chat_app/core/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.blueAccent.shade100,
      margin: EdgeInsets.symmetric(horizontal: mediaQuery(context).width * .01 , vertical: 4),
      child:  ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text("Contact Name"),
        subtitle: const Text("Last Message"),
        trailing: const Text("7:00 AM"),
        leading: const CircleAvatar(
          child: Icon(CupertinoIcons.person_2_alt),
        ),
      ),
    );
  }
}
