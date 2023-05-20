import 'package:chat_app/business/auth/auth_cubit.dart';
import 'package:chat_app/business/chats/chats_cubit.dart';
import 'package:chat_app/business/profile/profile_cubit.dart';
import 'package:chat_app/presentation/screens/auth/login_screen.dart';
import 'package:chat_app/presentation/screens/home_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/chat_user.dart';
import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/splash_screen.dart';
import 'constants/routes.dart';

class AppRouter {
  final AuthCubit authCubit;
  final ChatsCubit chatsCubit;

  AppRouter(this.authCubit, this.chatsCubit);

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.profileScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create:(_) => ProfileCubit(),
            child: const ProfileScreen(),
          ),
        );

      case AppRoutes.homeScreenRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authCubit),
              BlocProvider.value(value: chatsCubit)
            ],
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.splashScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.loginScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const LoginScreen(),
          ),
        );

      case AppRoutes.chatScreenRoute:
        final user = settings.arguments as ChatUser;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: chatsCubit,
            child: ChatScreen(
              user: user,
            ),
          ),
        );
      default:
        return null;
    }
  }
}
