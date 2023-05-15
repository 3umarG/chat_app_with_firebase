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
      BlocProvider.of<ChatsCubit>(context, listen: false).disableSearch();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values); // to re-show bars
    });
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is HomeScreenUiDisableSearchState) {
          searchController.clear();
        } else if (state is HomeScreenUiEnableSearchState) {
          ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(
            onRemove: () => context.read<ChatsCubit>().disableSearch(),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state is HomeScreenUiDisableSearchState
                ? const Text("Chat App")
                : _buildSearchBar(),
            centerTitle: true,
            leading: state is HomeScreenUiDisableSearchState
                ? const SizedBox.shrink()
                : const BackButton(),
            actions: [
              state is HomeScreenUiDisableSearchState
                  ? IconButton(
                      onPressed: () {
                        context.read<ChatsCubit>().enableSearch();
                      },
                      icon: const Icon(Icons.search))
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        context.read<ChatsCubit>().searchUser("");
                      },
                      icon: const Icon(Icons.close)),
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
          body: state is HomeScreenUiDisableSearchState
              ? _buildStreamUsers()
              : _buildSearchedUser(),
        );
      },
    );
  }

  _buildSearchBar() => TextField(
        controller: searchController,
        style: const TextStyle(
          letterSpacing: 2,
          fontSize: 18,
          color: Colors.blueAccent,
        ),
        onChanged: (searchQuery) {
          context.read<ChatsCubit>().searchUser(searchQuery);
        },
        decoration: const InputDecoration.collapsed(
          hintText: "Name ,Email ...",
          border: InputBorder.none,
          hintStyle: TextStyle(
            letterSpacing: 1,
            color: Colors.blueAccent,
            fontSize: 18,
          ),
        ),
        cursorColor: Colors.blueAccent,
        maxLines: 1,
      );

  _buildStreamUsers() => StreamBuilder(
      stream: context.read<ChatsCubit>().usersStream(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            final List<ChatUser> listOfUsers =
                context.read<ChatsCubit>().getUsersFromSnapshot(snapshot);
            return listOfUsers.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) => ChatCard(
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
      });

  _buildSearchedUser() {
    debugPrint("Controller : ${searchController.text}");
    if (searchController.text.trim().isNotEmpty) {
      debugPrint("Not Empty String Controller ");
      final List<ChatUser> searchedUsers =
          context.read<ChatsCubit>().searchedList;
      if (searchedUsers.isEmpty) {
        return _buildEmptyList();
      } else {
        return _buildListForSearch(searchedUsers);
      }
    } else {
      final List<ChatUser> listOfUsers =
          context.read<ChatsCubit>().allUsers;
      return _buildListForSearch(listOfUsers);
    }
  }

  _buildEmptyList() => SingleChildScrollView(
        child: Center(
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
                "There is no matching !!",
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

  _buildListForSearch(List<ChatUser> users) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => ChatCard(
        user: users[index],
      ),
      itemCount: users.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}
