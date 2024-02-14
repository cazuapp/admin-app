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

enum ServerInfoStatus { initial, loading, success, failure }

class ServerInfoState extends Equatable {
  const ServerInfoState(
      {required this.id, this.status = ServerInfoStatus.initial, required this.driverStats, required this.orderStats});

  ServerInfoState.initial()
      : this(
            id: 0,
            status: ServerInfoStatus.initial,
            orderStats: OrderStats.initial(),
            driverStats: DriverStats.initial());

  final ServerInfoStatus status;
  final DriverStats driverStats;
  final OrderStats orderStats;
  final int id;

  ServerInfoState copyWith(
      {int? id, Product? product, ServerInfoStatus? status, DriverStats? driverStats, OrderStats? orderStats}) {
    return ServerInfoState(
        id: id ?? this.id,
        status: status ?? this.status,
        driverStats: driverStats ?? this.driverStats,
        orderStats: orderStats ?? this.orderStats);
  }

  @override
  List<Object> get props => [id, status, driverStats, orderStats];
}
