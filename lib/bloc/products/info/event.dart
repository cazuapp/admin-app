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

abstract class ProductInfoEvent extends Equatable {
  const ProductInfoEvent();
}

class ProductInfoEventOK extends ProductInfoEvent {
  const ProductInfoEventOK();

  @override
  List<Object> get props => [];
}

class ProductInfoRequest extends ProductInfoEvent {
  const ProductInfoRequest();

  @override
  List<Object> get props => [];
}

class UpdateProduct extends ProductInfoEvent {
  const UpdateProduct({required this.id, required this.key, required this.value});

  final int id;
  final String key;
  final dynamic value;

  @override
  List<Object> get props => [id, key, value];
}

class DeleteProduct extends ProductInfoEvent {
  const DeleteProduct({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}

class FetchInfo extends ProductInfoEvent {
  const FetchInfo({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}
