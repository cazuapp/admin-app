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

abstract class ProductAddEvent extends Equatable {
  const ProductAddEvent();

  @override
  List<Object> get props => [];
}

class ProductOK extends ProductAddEvent {
  @override
  List<Object> get props => [];
}

class ProductAddProgress extends ProductAddEvent {
  const ProductAddProgress({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}

class ProductNameChanged extends ProductAddEvent {
  const ProductNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class ProductDescriptionChanged extends ProductAddEvent {
  const ProductDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class ProductPiorityChanged extends ProductAddEvent {
  const ProductPiorityChanged(this.piority);

  final int piority;

  @override
  List<Object> get props => [piority];
}



class SetCollection extends ProductAddEvent {
  const SetCollection({required this.collection, required this.collectionName});

  final int collection;
  final String collectionName;

  @override
  List<Object> get props => [collection, collectionName];
}

class ProductAddSubmitted extends ProductAddEvent {
  const ProductAddSubmitted();
}
