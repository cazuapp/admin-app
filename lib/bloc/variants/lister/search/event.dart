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

class VariantSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserFetched extends VariantSearchEvent {}

class SearchReset extends VariantSearchEvent {
  SearchReset();

  @override
  List<Object> get props => [];
}

class SetParam extends VariantSearchEvent {
  SetParam({required this.param});

  final Param param;

  @override
  List<Object> get props => [param];
}

class SearchRequest extends VariantSearchEvent {
  SearchRequest({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}

class OnScroll extends VariantSearchEvent {}

class Init extends VariantSearchEvent {}

class SetProduct extends VariantSearchEvent {
  SetProduct({required this.product});

  final int product;

  @override
  List<Object> get props => [product];
}
