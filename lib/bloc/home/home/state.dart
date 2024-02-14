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

enum HomeStatus { loading, initial, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final bool hasReachedMax;
  final List<OrderList> orders;
  final int total;
  final Param param;
  final String text;

  const HomeState({
    this.status = HomeStatus.initial,
    this.total = 0,
    this.hasReachedMax = false,
    this.orders = const <OrderList>[],
    this.param = Param.pending,
    this.text = "",
  });

  HomeState copyWith({
    HomeStatus? status,
    String? text,
    List<OrderList>? orders,
    int? total,
    bool? hasReachedMax,
    Param? param,
  }) {
    return HomeState(
      param: param ?? this.param,
      total: total ?? this.total,
      text: text ?? this.text,
      status: status ?? this.status,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, total, orders, hasReachedMax, param, text];
}
