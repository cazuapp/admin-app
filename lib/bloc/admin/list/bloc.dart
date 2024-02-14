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

class AdminMenuListBloc extends Bloc<AdminListEvent, AdminListState> {
  AppInstance instance;

  AdminMenuListBloc({required this.instance}) : super(const AdminListState()) {
    on<AdminFetch>(
      _onUserFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    /* Resets original status */

    on<Init>(_onInit);
  }

  Future<void> _onInit(
    Init event,
    Emitter<AdminListState> emit,
  ) async {
    emit(const AdminListState());
  }

  Future<void> _onUserFetch(
    AdminFetch event,
    Emitter<AdminListState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      if (state.status == AdminListStatus.initial) {
        emit(state.copyWith(status: AdminListStatus.loading));

        final posts = await _fetchListItems(emit: emit);

        posts.isEmpty
            ? emit(state.copyWith(status: AdminListStatus.success))
            : emit(
                state.copyWith(
                  status: AdminListStatus.success,
                  users: posts,
                  hasReachedMax: false,
                ),
              );

        return;
      }

      final posts = await _fetchListItems(emit: emit, startIndex: state.users.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: AdminListStatus.success))
          : emit(
              state.copyWith(
                status: AdminListStatus.success,
                users: List.of(state.users)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: AdminListStatus.failure));
    }
  }

  Future<List<User>> _fetchListItems({required Emitter<AdminListState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.users.adminList(offset: startIndex, limit: _postLimit);
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
