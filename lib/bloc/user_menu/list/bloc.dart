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

class UserMenuListBloc extends Bloc<UserListEvent, UserListState> {
  AppInstance instance;

  UserMenuListBloc({required this.instance}) : super(const UserListState()) {
    on<UserFetch>(
      _onUserFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    /* Resets original status */

    on<Init>(_onInit);
  }

  Future<void> _onInit(
    Init event,
    Emitter<UserListState> emit,
  ) async {
    emit(const UserListState());
  }

  Future<void> _onUserFetch(
    UserFetch event,
    Emitter<UserListState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      if (state.status == UserListStatus.initial) {
        emit(state.copyWith(status: UserListStatus.loading));

        final posts = await _fetchListItems(emit: emit);

        posts.isEmpty
            ? emit(state.copyWith(status: UserListStatus.success))
            : emit(
                state.copyWith(
                  status: UserListStatus.success,
                  users: posts,
                  hasReachedMax: false,
                ),
              );

        return;
      }

      final posts = await _fetchListItems(emit: emit, startIndex: state.users.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: UserListStatus.success))
          : emit(
              state.copyWith(
                status: UserListStatus.success,
                users: List.of(state.users)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: UserListStatus.failure));
    }
  }

  Future<List<User>> _fetchListItems({required Emitter<UserListState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.users.list(offset: startIndex, limit: _postLimit);
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
