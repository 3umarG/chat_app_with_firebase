import 'package:cached_network_image/cached_network_image.dart';
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
      margin: EdgeInsets.symmetric(
          horizontal: mediaQuery(context).width * .01, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text(user.name ?? "Name"),
        subtitle: Text(user.about ?? "About"),
        trailing: Container(width: 15, height: 15, decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),),
        // Text(user.lastActive ?? "7:00 AM"),
        leading: user.image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(mediaQuery(context).height * 0.3),
                child: CachedNetworkImage(
                  width: mediaQuery(context).height * 0.055,
                  height: mediaQuery(context).height * 0.055,
                  imageUrl: user.image!,
                  placeholder:(_ , s) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person_2_alt),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person_2_alt),
                  ),
                ),
              )
            : const CircleAvatar(
                child: Icon(CupertinoIcons.person_2_alt),
              ),
        // const CircleAvatar(
        //   child:  Icon(CupertinoIcons.person_2_alt),
        // ),
      ),
    );
  }
}
