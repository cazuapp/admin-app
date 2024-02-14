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
import 'package:cazuapp_admin/models/user.dart';
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

class DriverSearchBloc extends Bloc<DriverSearchEvent, DriverSearchState> {
  AppInstance instance;

  DriverSearchBloc({required this.instance}) : super(const DriverSearchState()) {
    on<SetParam>(_onSetParam);
    on<SetPick>(onSetPick);

    on<SearchRequest>(
      _onSearchRequest,
      transformer: throttleDroppable(throttleDuration),
    );

    on<OnScroll>(_onScroll);

    on<SearchReset>(_onSearchReset);
    on<Init>(_onInit);
  }

  Future<void> _onScroll(
    OnScroll event,
    Emitter<DriverSearchState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    await _onSearchRequest(SearchRequest(text: state.text), emit);
  }

  Future<void> onSetPick(
    SetPick event,
    Emitter<DriverSearchState> emit,
  ) async {
    final pick = event.pick;
    return emit(state.copyWith(pick: pick));
  }

  Future<void> _onInit(
    Init event,
    Emitter<DriverSearchState> emit,
  ) async {
    final query = state.text;

    emit(state.copyWith(text: query));
  }

  Future<void> _onSetParam(
    SetParam event,
    Emitter<DriverSearchState> emit,
  ) async {
    final change = event.param;

    emit(state.copyWith(param: change));
  }

  Future<void> _onSearchReset(
    SearchReset event,
    Emitter<DriverSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        total: 0,
        text: "",
        status: DriverSearchStatus.success,
        users: <User>[],
        hasReachedMax: false,
      ),
    );
  }

  Future<void> _onSearchRequest(SearchRequest event, Emitter<DriverSearchState> emit) async {
    final text = event.text;
    if (state.hasReachedMax) return;

    emit(state.copyWith(text: text));

    if (state.hasReachedMax) return;

    try {
      if (state.status == DriverSearchStatus.initial) {
        return emit(state.copyWith(status: DriverSearchStatus.success));
      }

      final posts = await _fetchResults(emit: emit, startIndex: state.users.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: DriverSearchStatus.success))
          : emit(
              state.copyWith(
                status: DriverSearchStatus.success,
                users: List.of(state.users)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: DriverSearchStatus.failure));
    }
  }

  Future<List<User>> _fetchResults({required Emitter<DriverSearchState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.drivers.search(value: state.text, offset: startIndex, limit: _postLimit);

    emit(state.copyWith(total: response?.model2));

    if (response?.status == Protocol.empty) {
      return List<User>.empty();
    }

    if (response?.model.isEmpty) {
      return List<User>.empty();
    }

    return response?.model.toList();
  }
}
