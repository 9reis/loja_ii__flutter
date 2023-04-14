import 'dart:developer';

import 'package:flutter/material.dart';

// Armazena o estado que será manipulado no provider
class CounterState {
  int _value = 0;

  void inc() => _value++;
  void dec() => _value--;

  int get value => _value;

  bool diff(CounterState old) {
    return old._value != _value;
  }
}

class CounteProvider extends InheritedWidget {
  final CounterState state = CounterState();

  CounteProvider({required Widget child}) : super(child: child);

  static CounteProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounteProvider>();
  }

  @override
  bool updateShouldNotify(covariant CounteProvider oldWidget) {
    return oldWidget.state.diff(state);
    throw UnimplementedError();
  }
}
