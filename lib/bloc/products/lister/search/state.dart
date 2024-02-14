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

enum ProductSearchStatus { loading, initial, success, failure }

class ProductSearchState extends Equatable {
  final ProductSearchStatus status;
  final bool hasReachedMax;
  final List<ProductListItem> products;
  final int total;
  final String text;
  final int collection;
  final Param param;
  final bool pick;

  const ProductSearchState({
    this.status = ProductSearchStatus.initial,
    this.hasReachedMax = false,
    this.products = const <ProductListItem>[],
    this.total = 0,
    this.collection = 0,
    this.text = '',
    this.param = Param.all,
    this.pick = false,
  });

  ProductSearchState copyWith({
    String? text,
    Param? param,
    int? collection,
    ProductSearchStatus? status,
    int? total,
    bool? pick,
    List<ProductListItem>? products,
    bool? hasReachedMax,
  }) {
    return ProductSearchState(
      param: param ?? this.param,
      text: text ?? this.text,
      collection: collection ?? this.collection,
      status: status ?? this.status,
      total: total ?? this.total,
      pick: pick ?? this.pick,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ProductSearchStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, products, total, hasReachedMax, text, param, collection, pick];
}
