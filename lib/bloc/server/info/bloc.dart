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

import 'package:cazuapp_admin/models/driver_stats.dart';
import 'package:cazuapp_admin/models/order_stats.dart';
import 'package:cazuapp_admin/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/dual.dart';

import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class ServerInfoBloc extends Bloc<ServerInfoEvent, ServerInfoState> {
  final AppInstance instance;

  ServerInfoBloc({required this.instance}) : super(ServerInfoState.initial()) {
    on<ServerInfoEventOK>(_onOK);
    on<FetchDriverStats>(_onFetchDriverStats);
    on<ServerResetCache>(_onServerResetCache);

    on<FetchOrderStats>(_onOrderStats);
  }

  Future<void> _onServerResetCache(ServerResetCache event, Emitter<ServerInfoState> emit) async {
    emit(state.copyWith(status: ServerInfoStatus.loading));

    DualResult? response = await instance.server.resetcache();

    if (response?.status == Protocol.ok) {
      emit(state.copyWith(status: ServerInfoStatus.success));
    }
  }

  Future<void> _onOK(ServerInfoEventOK event, Emitter<ServerInfoState> emit) async {
    emit(ServerInfoState.initial());
  }

  Future<void> _onFetchDriverStats(FetchDriverStats event, Emitter<ServerInfoState> emit) async {
    emit(state.copyWith(status: ServerInfoStatus.loading));

    DualResult? response = await instance.drivers.stats();

    if (response?.status == Protocol.ok) {
      emit(state.copyWith(status: ServerInfoStatus.success, driverStats: response?.model));
    }
  }

  Future<void> _onOrderStats(FetchOrderStats event, Emitter<ServerInfoState> emit) async {
    emit(state.copyWith(status: ServerInfoStatus.loading));

    DualResult? response = await instance.orders.stats();

    if (response?.status == Protocol.ok) {
      emit(state.copyWith(status: ServerInfoStatus.success, orderStats: response?.model));
    }
  }
}
