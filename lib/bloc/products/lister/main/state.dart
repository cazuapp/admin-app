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

enum ListStatus { loading, initial, success, failure }

class ListState extends Equatable {
  final ListStatus status;
  final bool hasReachedMax;
  final List<ProductListItem> products;
  final Param param;
  final int total;
  final String text;
  final int collection;
  final bool pick;

  const ListState({
    this.status = ListStatus.initial,
    this.hasReachedMax = false,
    this.total = 0,
    this.products = const <ProductListItem>[],
    this.param = Param.pending,
    this.text = "",
    this.collection = 0,
    this.pick = false,
  });

  ListState copyWith({
    ListStatus? status,
    String? text,
    String? collectionTitle,
    int? total,
    List<ProductListItem>? products,
    bool? hasReachedMax,
    Param? param,
    bool? pick,
    int? collection,
  }) {
    return ListState(
      param: param ?? this.param,
      total: total ?? this.total,
      pick: pick ?? this.pick,
      text: text ?? this.text,
      collection: collection ?? this.collection,
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ListStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax, param, total, text, collection, pick];
}
