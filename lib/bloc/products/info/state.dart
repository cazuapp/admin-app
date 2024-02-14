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

enum ProductInfoStatus { initial, loading, success, failure, deleted }

class ProductInfoState extends Equatable {
  const ProductInfoState(
      {required this.id, required this.product, required this.errmsg, this.status = ProductInfoStatus.initial});

  const ProductInfoState.initial()
      : this(id: 0, status: ProductInfoStatus.initial, errmsg: "", product: const Product.initial());

  final Product product;
  final ProductInfoStatus status;
  final int id;
  final String errmsg;

  ProductInfoState copyWith({int? id, Product? product, ProductInfoStatus? status, String? errmsg}) {
    return ProductInfoState(
        id: id ?? this.id,
        product: product ?? this.product,
        status: status ?? this.status,
        errmsg: errmsg ?? this.errmsg);
  }

  @override
  List<Object> get props => [product, id, status, errmsg];
}
