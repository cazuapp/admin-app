/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

part of 'bloc.dart';

abstract class CollectionAddEvent extends Equatable {
  const CollectionAddEvent();

  @override
  List<Object> get props => [];
}

class CollectionAddProgress extends CollectionAddEvent {
  const CollectionAddProgress({required this.collection});

  final Collection collection;

  @override
  List<Object> get props => [collection];
}

class CollectionTitleChanged extends CollectionAddEvent {
  const CollectionTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class CollectionImageChanged extends CollectionAddEvent {
  const CollectionImageChanged(this.image);

  final String image;

  @override
  List<Object> get props => [image];
}

class CollectionOK extends CollectionAddEvent {
  @override
  List<Object> get props => [];
}

class CollectionPiorityChanged extends CollectionAddEvent {
  const CollectionPiorityChanged(this.piority);

  final int piority;

  @override
  List<Object> get props => [piority];
}

class CollectionAddSubmitted extends CollectionAddEvent {
  const CollectionAddSubmitted();
}

class SetImage extends CollectionAddEvent {
  const SetImage({required this.path});

  final String path;

  @override
  List<Object> get props => [path];
}
