import 'package:chat_app/business/auth/auth_cubit.dart';
import 'package:chat_app/business/chats/chats_cubit.dart';
import 'package:chat_app/presentation/screens/auth/login_screen.dart';
import 'package:chat_app/presentation/screens/home_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/screens/splash_screen.dart';
import 'constants/routes.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);



  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.profileScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value:authCubit,
            child: const ProfileScreen(),
          ),
        );


      case AppRoutes.homeScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ChatsCubit(),
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
            value:authCubit,
            child: const LoginScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
