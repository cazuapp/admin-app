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
import 'package:cazuapp_admin/models/collection.dart';
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

class CollectionListBloc extends Bloc<ListEvent, ListState> {
  AppInstance instance;

  CollectionListBloc({required this.instance}) : super(const ListState()) {
    on<ListFetch>(
      _onListFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    on<SetPick>(onSetPick);

    on<Init>(_onInit);
  }

  Future<void> onSetPick(
    SetPick event,
    Emitter<ListState> emit,
  ) async {
    final pick = event.pick;
    return emit(state.copyWith(pick: pick));
  }

  Future<void> _onInit(
    Init event,
    Emitter<ListState> emit,
  ) async {
    emit(const ListState());
  }

  Future<void> _onListFetch(
    ListFetch event,
    Emitter<ListState> emit,
  ) async {
    try {
      if (state.status == ListStatus.initial) {
        final posts = await _fetchListItems(emit: emit);

        return emit(
          state.copyWith(
            status: ListStatus.success,
            collections: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts = await _fetchListItems(emit: emit, startIndex: state.collections.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ListStatus.success,
                collections: List.of(state.collections)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: ListStatus.failure));
    }
  }

  Future<List<Collection>> _fetchListItems({required Emitter<ListState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.collections.list(offset: startIndex, limit: _postLimit);

    emit(state.copyWith(total: response?.model2));

    if (response?.status == Protocol.empty) {
      return List<Collection>.empty();
    }

    if (response?.model.isEmpty) {
      return List<Collection>.empty();
    }

    return response?.model.toList();
  }
}
