import 'package:flutter/material.dart';

enum TransitionType {
  slide,
  fade,
  scale,
  rotation,
  slideFade,
  scaleRotate,
}

class CustomRoute {
  /// Creates a type-safe custom animated route
  static PageRoute<T> _createRoute<T>(Widget page, {TransitionType transition = TransitionType.slide}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transition) {
          case TransitionType.fade:
            return _buildFadeTransition(animation, child);
          case TransitionType.scale:
            return _buildScaleTransition(animation, child);
          case TransitionType.rotation:
            return _buildRotationTransition(animation, child);
          case TransitionType.slideFade:
            return _buildSlideFadeTransition(animation, child);
          case TransitionType.scaleRotate:
            return _buildScaleRotateTransition(animation, child);
          case TransitionType.slide:
          default:
            return _buildSlideTransition(animation, child);
        }
      },
    );
  }

  /// Slide transition (default)
  static Widget _buildSlideTransition(Animation<double> animation, Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutQuart;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Fade transition
  static Widget _buildFadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  /// Scale transition
  static Widget _buildScaleTransition(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        ),
      ),
      child: child,
    );
  }

  /// Rotation transition
  static Widget _buildRotationTransition(Animation<double> animation, Widget child) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
      ),
      child: child,
    );
  }

  /// Combined slide and fade transition
  static Widget _buildSlideFadeTransition(Animation<double> animation, Widget child) {
    const slideBegin = Offset(0.0, 0.5);
    const slideEnd = Offset.zero;
    
    final slideTween = Tween(begin: slideBegin, end: slideEnd);
    final fadeTween = Tween(begin: 0.0, end: 1.0);

    return SlideTransition(
      position: animation.drive(slideTween.chain(CurveTween(curve: Curves.easeOutQuint))),
      child: FadeTransition(
        opacity: animation.drive(fadeTween.chain(CurveTween(curve: Curves.easeOut))),
        child: child,
      ),
    );
  }

  /// Combined scale and rotation transition
  static Widget _buildScaleRotateTransition(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
      ),
      child: RotationTransition(
        turns: Tween<double>(begin: -0.5, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      ),
    );
  }

  /// Type-safe push with custom transition
  static Future<T?> push<T>(BuildContext context, Widget page,
      {TransitionType transition = TransitionType.slide}) {
    return Navigator.of(context).push<T>(
      _createRoute<T>(page, transition: transition),
    );
  }

  /// Type-safe push replacement with custom transition
  static Future<T?> pushReplacement<T>(BuildContext context, Widget page,
      {TransitionType transition = TransitionType.slide}) {
    return Navigator.of(context).pushReplacement<T, T>(
      _createRoute<T>(page, transition: transition),
    );
  }

  /// Type-safe push and remove until with custom transition
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget page,
      {TransitionType transition = TransitionType.slide, bool Function(Route<dynamic>)? predicate}) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      _createRoute<T>(page, transition: transition),
      predicate ?? (route) => false,
    );
  }
}