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

class ProductSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserFetched extends ProductSearchEvent {}

class SearchReset extends ProductSearchEvent {
  SearchReset();

  @override
  List<Object> get props => [];
}

class SetParam extends ProductSearchEvent {
  SetParam({required this.param});

  final Param param;

  @override
  List<Object> get props => [param];
}

class SearchRequest extends ProductSearchEvent {
  SearchRequest({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}

class OnScroll extends ProductSearchEvent {}

class Init extends ProductSearchEvent {}

class SetCollection extends ProductSearchEvent {
  SetCollection({required this.collection});

  final int collection;

  @override
  List<Object> get props => [collection];
}

class SetPick extends ProductSearchEvent {
  SetPick({required this.pick});

  final bool pick;

  @override
  List<Object> get props => [pick];
}
