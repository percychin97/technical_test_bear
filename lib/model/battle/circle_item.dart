import 'package:flutter/material.dart';

enum CircleVariant { red, blue, green, dark, light, solved }

enum DraggingState {
  ready,
  dragging
}

class CircleItem {
  final CircleVariant variant;

  CircleItem(this.variant, {List props = const []})
      : super();

  Icon getIcon(double size, {int alpha = 255}) {
    switch (variant) {
      case CircleVariant.red:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.red.withAlpha(alpha));
      case CircleVariant.blue:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.blue.withAlpha(alpha));
      case CircleVariant.green:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.lightGreen.withAlpha(alpha));
      case CircleVariant.dark:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.yellow.withAlpha(alpha));
      case CircleVariant.light:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.deepPurple.withAlpha(alpha));
      case CircleVariant.solved:
        return Icon(
          Icons.blur_circular,
          size: size,
          color: Colors.transparent,
        );
    }

  }

  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
