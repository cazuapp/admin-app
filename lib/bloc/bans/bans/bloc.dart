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

class BansHomeBloc extends Bloc<BansHomeEvent, BansHomeState> {
  AppInstance instance;

  BansHomeBloc({required this.instance}) : super(const BansHomeState()) {
    on<BansHomeFetch>(
      _onBansHomeFetch,
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
    Emitter<BansHomeState> emit,
  ) async {
    emit(const BansHomeState());
  }

  Future<void> _onSetText(
    SetText event,
    Emitter<BansHomeState> emit,
  ) async {
    final change = event.text;
    emit(state.copyWith(text: change));
  }

  Future<void> _onHomeScroll(
    OnHomeScroll event,
    Emitter<BansHomeState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    await _onBansHomeFetch(BansHomeFetch(), emit);
  }

  Future<void> _onBansHomeFetch(
    BansHomeFetch event,
    Emitter<BansHomeState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      if (state.status == BanHomeStatus.initial) {
        emit(state.copyWith(status: BanHomeStatus.loading));

        final posts = await _fetchBansHomeItems(emit: emit);

        posts.isEmpty
            ? emit(state.copyWith(status: BanHomeStatus.success))
            : emit(
                state.copyWith(
                  status: BanHomeStatus.success,
                  bans: posts,
                  hasReachedMax: false,
                ),
              );

        return;
      }

      final posts = await _fetchBansHomeItems(emit: emit, startIndex: state.bans.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: BanHomeStatus.success))
          : emit(
              state.copyWith(
                status: BanHomeStatus.success,
                bans: List.of(state.bans)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: BanHomeStatus.failure));
    }
  }

  Future<List<BanListItem>> _fetchBansHomeItems({required Emitter<BansHomeState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.bans.list(offset: startIndex, limit: _postLimit, param: state.param);
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
