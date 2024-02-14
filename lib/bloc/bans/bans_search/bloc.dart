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
import 'package:cazuapp_admin/models/ban.dart';
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

class BanSearchBloc extends Bloc<BanSearchEvent, BanSearchState> {
  AppInstance instance;

  BanSearchBloc({required this.instance}) : super(const BanSearchState()) {
    on<SetParam>(_onSetParam);

    on<SearchRequest>(
      _onSearchRequest,
      transformer: throttleDroppable(throttleDuration),
    );

    on<SearchReset>(_onSearchReset);
    on<OnScroll>(_onScroll);
    on<Init>(_onInit);
  }

  Future<void> _onInit(
    Init event,
    Emitter<BanSearchState> emit,
  ) async {
    final query = state.text;

    emit(state.copyWith(text: query));
  }

  Future<void> _onSetParam(
    SetParam event,
    Emitter<BanSearchState> emit,
  ) async {
    final change = event.param;

    emit(state.copyWith(param: change));
  }

  Future<void> _onSearchReset(
    SearchReset event,
    Emitter<BanSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        total: 0,
        text: "",
        status: BanSearchStatus.success,
        bans: <BanListItem>[],
        hasReachedMax: false,
      ),
    );
  }

  Future<void> _onSearchRequest(SearchRequest event, Emitter<BanSearchState> emit) async {
    final text = event.text;
    if (state.hasReachedMax) return;

    emit(state.copyWith(text: text));

    if (state.hasReachedMax) return;

    try {
      if (state.status == BanSearchStatus.initial) {
        return emit(state.copyWith(status: BanSearchStatus.success));
      }

      final posts = await _fetchResults(emit: emit, startIndex: state.bans.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: BanSearchStatus.success))
          : emit(
              state.copyWith(
                status: BanSearchStatus.success,
                bans: List.of(state.bans)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: BanSearchStatus.failure));
    }
  }

  Future<void> _onScroll(
    OnScroll event,
    Emitter<BanSearchState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    await _onSearchRequest(SearchRequest(text: state.text), emit);
  }

  Future<List<BanListItem>> _fetchResults({required Emitter<BanSearchState> emit, int startIndex = 0}) async {
    DualResult? response =
        await instance.bans.search(text: state.text, offset: startIndex, limit: _postLimit, param: state.param);

    emit(state.copyWith(total: response?.model2));

    if (response?.status == Protocol.empty) {
      return List<BanListItem>.empty();
    }

    if (response?.model.isEmpty) {
      return List<BanListItem>.empty();
    }

    return response?.model.toList();
  }
}
