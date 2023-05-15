import 'package:chat_app/business/chats/chats_cubit.dart';
import 'package:chat_app/data/models/chat_user.dart';
import 'package:chat_app/presentation/widgets/chat_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/routes.dart';
import '../../core/media_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values); // to re-show bars
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        centerTitle: true,
        leading: const Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileScreenRoute);
            },
            icon: const Icon(Icons.person),
          ),

        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.chat_outlined),
        ),
      ),
      body: StreamBuilder(
          stream: context
              .read<ChatsCubit>()
              .usersStream(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                final List<ChatUser> listOfUsers = List<ChatUser>.from(
                    snapshot
                        .data!.docs
                        .map((e) => ChatUser.fromJson(e.data())));
                return listOfUsers.isNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) =>
                      ChatCard(
                        user: listOfUsers[index],
                      ),
                  itemCount: listOfUsers.length,
                  physics: const BouncingScrollPhysics(),
                )
                    : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/empty.png",
                        width: mediaQuery(context).width * .5,
                        height: mediaQuery(context).height * .5,
                      ),
                      const Text(
                        "There is no Chats , yet !!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                );
            }
            // if (snapshot.connectionState == ConnectionState.waiting) {
            // } else if (snapshot.hasData) {
            //
            // } else if (snapshot.hasError) {
            //   return Center(
            //     child: Text(snapshot.error!.toString()),
            //   );
            // } else {
            //   return const SizedBox.shrink();
            // }
          }),
    );
  }
}
