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

import 'dart:async';

import 'package:cazuapp_admin/core/defaults.dart';
import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/models/order_list.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  AppInstance instance;

  HomeBloc({required this.instance}) : super(const HomeState()) {
    on<HomeFetch>(
      _onHomeFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    /* Resets original status */

    on<Init>(_onInit);

    /* Invoked as home is scrolled down */

    on<OnHomeScroll>(_onHomeScroll);

    on<SetText>(_onSetText);
  }

  Future<void> _onInit(
    Init event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState());
  }

  Future<void> _onSetText(
    SetText event,
    Emitter<HomeState> emit,
  ) async {
    final change = event.text;
    emit(state.copyWith(text: change));
  }

  Future<void> _onHomeScroll(
    OnHomeScroll event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    await _onHomeFetch(HomeFetch(), emit);
  }

  Future<void> _onHomeFetch(
    HomeFetch event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      if (state.status == HomeStatus.initial) {
        emit(state.copyWith(status: HomeStatus.loading));

        final posts = await _fetchHomeItems(emit: emit);

        posts.isEmpty
            ? emit(state.copyWith(status: HomeStatus.success))
            : emit(
                state.copyWith(
                  status: HomeStatus.success,
                  orders: posts,
                  hasReachedMax: false,
                ),
              );

        return;
      }

      final posts = await _fetchHomeItems(emit: emit, startIndex: state.orders.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: HomeStatus.success))
          : emit(
              state.copyWith(
                status: HomeStatus.success,
                orders: List.of(state.orders)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<List<OrderList>> _fetchHomeItems({required Emitter<HomeState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.orders.home(offset: startIndex, limit: _postLimit, param: state.param);
    emit(state.copyWith(total: response?.model2));

    if (response?.status == Protocol.empty) {
      return List<OrderList>.empty();
    }

    if (response?.model.isEmpty) {
      return List<OrderList>.empty();
    }

    return response?.model.toList();
  }
}
