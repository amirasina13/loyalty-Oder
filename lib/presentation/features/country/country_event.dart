import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/* Events tell BLoC to do something. An event can be fired from anywhere, such as from a UI widget. 
External events, such as changes in network connectivity, changes in sensor readings */

/* Events class are an application’s inputs (like button_press to load images, text inputs, call API or any 
other user input that our app may hope to receive) */

// List event for country
@immutable
abstract class CountryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CountryLoad extends CountryEvent {
  @override
  String toString() => 'CountryLoad';
}
