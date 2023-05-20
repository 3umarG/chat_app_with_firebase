import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/chat_user.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/presentation/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business/chats/chats_cubit.dart';
import '../../core/media_query.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildChatScreenAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: _buildStreamChats(),
            ),
          ),
          _buildTypeBar(context),
        ],
      ),
    );
  }

  _buildCircleAvatar(BuildContext context) {
    return widget.user.image != null
        ? ClipRRect(
            borderRadius:
                BorderRadius.circular(mediaQuery(context).height * 0.3),
            child: CachedNetworkImage(
              width: mediaQuery(context).height * 0.05,
              height: mediaQuery(context).height * 0.05,
              imageUrl: widget.user.image!,
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
                  widget.user.name!,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  "Last Seen not available",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
          ],
        ),
      );

  _buildTypeBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mediaQuery(context).height * 0.01,
          horizontal: mediaQuery(context).width * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  _buildIconForTypeBar(Icons.emoji_emotions),
                   Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Colors.blueAccent,
                      decoration: const InputDecoration(
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: const CircleBorder(),
            onPressed: () {
              if(_textController.text.trim().isNotEmpty){
                context.read<ChatsCubit>().sendMessage(widget.user, _textController.text);
                _textController.clear();
                _textController.text = "";
              }
            },
            child:
                const Icon(Icons.send_outlined, color: Colors.white, size: 28),
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

  _buildStreamChats() => StreamBuilder(
      stream: context.read<ChatsCubit>().messagesStream(widget.user),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:

            final List<Message> listOfChats = context
                .read<ChatsCubit>()
                .getMessagesListFromSnapshot(snapshot);
            return listOfChats.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) =>
                        MessageCard(message: listOfChats[index]),
                    itemCount: listOfChats.length,
                    physics: const BouncingScrollPhysics(),
                  )
                : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/empty.png",
                            width: mediaQuery(context).width * .35,
                            height: mediaQuery(context).height * .35,
                          ),
                          const Text(
                            "Say Hi  👋",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
        }
      });
}
