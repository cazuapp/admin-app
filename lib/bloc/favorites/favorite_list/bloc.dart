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

import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../../core/defaults.dart';
import '../../../components/dual.dart';
import '../../../core/protocol.dart';
import '../../../models/product.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  AppInstance instance;

  FavoriteBloc({required this.instance}) : super(const FavoriteState()) {
    on<FavoritesFetched>(_onCollectionFetched, transformer: throttleDroppable(throttleDuration));

    on<FavoritesOK>(_onOk);

    on<UserSet>(_onUserSet);
  }

  Future<void> _onUserSet(UserSet event, Emitter<FavoriteState> emit) async {
    final id = event.id;
    emit(state.copyWith(userid: id));
  }

  Future<void> _onOk(
    FavoritesOK event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(const FavoriteState());
  }

  Future<void> _onCollectionFetched(
    FavoritesFetched event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == FavoriteStatus.initial) {
        emit(state.copyWith(status: FavoriteStatus.loading));

        final products = await _fetchItems(emit: emit);
        return emit(
          state.copyWith(
            status: FavoriteStatus.success,
            products: products,
            hasReachedMax: false,
          ),
        );
      }

      final products = await _fetchItems(emit: emit, startIndex: state.products.length);
      emit(state.copyWith(status: FavoriteStatus.loading));

      products.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: FavoriteStatus.success))
          : emit(
              state.copyWith(
                status: FavoriteStatus.success,
                products: List.of(state.products)..addAll(products),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  Future<List<Product>> _fetchItems({required Emitter<FavoriteState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.users.favorites(over: state.userid, offset: startIndex, limit: _postLimit);

    emit(state.copyWith(total: response?.model2));

    if (response?.status == Protocol.empty) {
      return List<Product>.empty();
    }

    if (response?.model.isEmpty) {
      return List<Product>.empty();
    }

    return response?.model.toList();
  }
}
