import 'package:flutter/material.dart';

class SlideBottomRoute extends PageRouteBuilder {
  final Widget page;
  final dynamic arguments;
  SlideBottomRoute({required this.page, this.arguments})
      : super(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.ease)).animate(animation),
                  child: child,
                ),
            settings: RouteSettings(arguments: arguments));
}
