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

enum FavoriteStatus { initial, success, failure, loading }

class FavoriteState extends Equatable {
  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
    this.userid = 0,
    this.total = 0,
  });

  final FavoriteStatus status;
  final List<Product> products;
  final bool hasReachedMax;
  final int userid;
  final int total;

  FavoriteState copyWith({
    int? userid,
    int? total,
    FavoriteStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return FavoriteState(
      total: total ?? this.total,
      userid: userid ?? this.userid,
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''FavoriteState { status: $status, hasReachedMax: $hasReachedMax, posts: ${products.length} }''';
  }

  @override
  List<Object> get props => [total, status, userid, products, hasReachedMax];
}
