import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/* Events tell BLoC to do something. An event can be fired from anywhere, such as from a UI widget. 
   External events, such as changes in network connectivity, changes in sensor readings */

/* Events class are an application’s inputs (like button_press to load images, text inputs, or any 
   other user input that our app may hope to receive) */

// List of event for bulletin
@immutable
abstract class BulletinEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class BulletinListLoad extends BulletinEvent {
  final String type;

  BulletinListLoad({required this.type});

  @override
  List<Object> get props => [type];
}

@immutable
class BulletinDetailsLoad extends BulletinEvent {
  final String bulletinId;

  BulletinDetailsLoad({required this.bulletinId});

  @override
  List<Object> get props => [bulletinId];
}
