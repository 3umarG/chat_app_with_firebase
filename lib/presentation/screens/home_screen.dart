import 'package:chat_app/business/chats/chats_cubit.dart';
import 'package:chat_app/presentation/widgets/chat_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.chat_outlined),
        ),
      ),
      body: BlocConsumer<ChatsCubit, ChatsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return StreamBuilder(
              stream: context
                  .read<ChatsCubit>()
                  .firestore
                  .collection("users")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final listOfUsers = snapshot.data!.docs.map((e) => e.data());
                  debugPrint(listOfUsers.toString());
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) => const ChatCard(),
                    itemCount: listOfUsers.length,
                    physics: const BouncingScrollPhysics(),
                  );
                } else if(snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error!.toString()),
                  );
                }else{
                  return const SizedBox.shrink();
                }
              });
        },
      ),
    );
  }
}
