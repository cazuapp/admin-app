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

abstract class VariantAddEvent extends Equatable {
  const VariantAddEvent();

  @override
  List<Object> get props => [];
}

class SetProduct extends VariantAddEvent {
  const SetProduct({required this.product, required this.productName});

  final int product;
  final String productName;

  @override
  List<Object> get props => [product, productName];
}

class TitleChanged extends VariantAddEvent {
  const TitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class VariantImageChanged extends VariantAddEvent {
  const VariantImageChanged(this.image);

  final String image;

  @override
  List<Object> get props => [image];
}

class VariantOK extends VariantAddEvent {
  @override
  List<Object> get props => [];
}

class PriceChanged extends VariantAddEvent {
  const PriceChanged(this.price);

  final double price;

  @override
  List<Object> get props => [price];
}

class VariantAddSubmitted extends VariantAddEvent {
  const VariantAddSubmitted();
}

class SetImage extends VariantAddEvent {
  const SetImage({required this.path});

  final String path;

  @override
  List<Object> get props => [path];
}
