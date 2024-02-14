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

enum VariantSearchStatus { loading, initial, success, failure }

class VariantSearchState extends Equatable {
  final VariantSearchStatus status;
  final bool hasReachedMax;
  final List<VariantListItem> variants;
  final int total;
  final String text;
  final int product;
  final Param param;
  final String productName;

  const VariantSearchState(
      {this.status = VariantSearchStatus.initial,
      this.hasReachedMax = false,
      this.variants = const <VariantListItem>[],
      this.total = 0,
      this.product = 0,
      this.text = '',
      this.param = Param.all,
      this.productName = ""});

  VariantSearchState copyWith({
    String? text,
    Param? param,
    int? product,
    VariantSearchStatus? status,
    int? total,
    List<VariantListItem>? variants,
    bool? hasReachedMax,
    String? productName,
  }) {
    return VariantSearchState(
      param: param ?? this.param,
      text: text ?? this.text,
      product: product ?? this.product,
      status: status ?? this.status,
      total: total ?? this.total,
      variants: variants ?? this.variants,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      productName: productName ?? this.productName,
    );
  }

  @override
  String toString() {
    return '''VariantSearchStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, variants, total, hasReachedMax, text, param, product];
}
