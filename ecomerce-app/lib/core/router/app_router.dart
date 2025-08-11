import 'package:flutter/material.dart';

import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/add_update_page.dart';
import '../../features/product/presentation/pages/details_page.dart';
import '../../features/product/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/search.dart';
import '../../features/authentication/presentation/pages/splash_controller.dart';
import '../../features/authentication/presentation/pages/sign_in_page.dart';
import '../../features/authentication/presentation/pages/sign_up_page.dart';
// import '../../features/authentication/presentation/pages/home_page.dart';
import '../../features/chat/domain/entities/chat.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fadeTransition(const SplashController());
      case '/home':
        return _fadeTransition(const HomePage());
      case '/signup':
        return _fadeTransition(const SignUpPage());
      case '/signin':
        return _fadeTransition(const SignInPage());
      case '/details':
        final product = settings.arguments as Product;
        return _slideTransition(ProductDetailsPage(product: product));
      case '/update':
        final product = settings.arguments as Product?;
        return _scaleFadeTransition(AddUpdatePage(product: product));
      case '/search': // <-- new case
        return _fadeTransition(const SearchPage());
      case '/chats':
        return _fadeTransition(const ChatListPage());
      case '/chat-detail':
        final chat = settings.arguments as Chat;
        return _slideTransition(ChatDetailPage(chat: chat));
      case '/chat-home':
        return _fadeTransition(const ChatListPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder _fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _scaleFadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(animation);
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
