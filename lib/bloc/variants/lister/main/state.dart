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
  final List<VariantListItem> variants;
  final Param param;
  final int total;
  final String text;
  final int product;
  final String productName;

  const ListState(
      {this.status = ListStatus.initial,
      this.hasReachedMax = false,
      this.total = 0,
      this.variants = const <VariantListItem>[],
      this.param = Param.pending,
      this.text = "",
      this.product = 0,
      this.productName = ""});

  ListState copyWith({
    ListStatus? status,
    String? text,
    int? total,
    List<VariantListItem>? variants,
    bool? hasReachedMax,
    Param? param,
    int? product,
    String? productName,
  }) {
    return ListState(
      param: param ?? this.param,
      total: total ?? this.total,
      text: text ?? this.text,
      product: product ?? this.product,
      status: status ?? this.status,
      variants: variants ?? this.variants,
      productName: productName ?? this.productName,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ListStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, variants, hasReachedMax, param, total, text, product, productName];
}
