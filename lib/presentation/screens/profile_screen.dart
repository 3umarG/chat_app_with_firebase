import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/business/auth/auth_cubit.dart';
import 'package:chat_app/core/constants/routes.dart';
import 'package:chat_app/data/api/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/dialogs.dart';
import '../../core/media_query.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<AuthCubit>(context, listen: false).getTheCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        listenWhen: (oldState, newState) => newState is AuthProfileInfoState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case AuthProfileInfoLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case AuthProfileInfoErrorState:
              return const Center(
                child: Text(
                  "Error Occured while fetching your information !!",
                ),
              );
            case AuthProfileInfoSuccessState:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQuery(context).height * 0.06,
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                mediaQuery(context).height * 0.1),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              width: mediaQuery(context).height * 0.2,
                              height: mediaQuery(context).height * 0.2,
                              imageUrl: ApiServices.user.photoURL!,
                              placeholder: (_, s) => const CircleAvatar(
                                child: Icon(CupertinoIcons.person_2_alt),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                child: Icon(CupertinoIcons.person_2_alt),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            right: -20,
                            child: MaterialButton(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 2,
                              onPressed: () {},
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: mediaQuery(context).height * 0.02,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          ApiServices.user.email!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery(context).height * 0.08,
                      ),
                      TextFormField(
                        initialValue: ApiServices.user.displayName,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor: Colors.blueAccent,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: "eg. Omar Gomaa",
                            label: const Text("Name")),
                      ),
                      SizedBox(
                        height: mediaQuery(context).height * 0.025,
                      ),
                      TextFormField(
                        initialValue:
                            context.read<AuthCubit>().currentUser!.about,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.info_outline),
                            prefixIconColor: Colors.blueAccent,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: "eg. I am Happy !!",
                            label: const Text("About")),
                      ),
                      SizedBox(
                        height: mediaQuery(context).height * 0.03,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(mediaQuery(context).width * .4,
                              mediaQuery(context).height * .055),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignOutLoadingState) {
            Dialogs.showLoadingDialog(context);
          } else if (state is AuthSignOutErrorState) {
            Navigator.pop(context);
            Dialogs.showErrorSnackBar(context);
          } else if (state is AuthSignOutSuccessState) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 8),
          child: Builder(builder: (context) {
            return FloatingActionButton.extended(
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
              label: const Text("Logout"),
              icon: const Icon(Icons.logout),
              backgroundColor: Colors.red,
            );
          }),
        ),
      ),
    );
  }
}
