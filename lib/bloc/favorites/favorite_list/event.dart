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

class FavoriteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoritesFetched extends FavoriteEvent {}

class FavoritesOK extends FavoriteEvent {}

class UserSet extends FavoriteEvent {
  UserSet({required this.id});

  final int id;

  @override
  List<Object> get props => [int];
}
