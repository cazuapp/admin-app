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
import 'package:cazuapp_admin/models/variant_list.dart';
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

class VariantListBloc extends Bloc<ListEvent, ListState> {
  AppInstance instance;

  VariantListBloc({required this.instance}) : super(const ListState()) {
    on<ListFetch>(
      _onListFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    on<SetProduct>(_onSetProduct);

    on<Init>(_onInit);
  }

  Future<void> _onInit(
    Init event,
    Emitter<ListState> emit,
  ) async {
    emit(const ListState());
  }

  Future<void> _onSetProduct(
    SetProduct event,
    Emitter<ListState> emit,
  ) async {
    final product = event.product;
    return emit(state.copyWith(product: product));
  }

  Future<void> _onListFetch(
    ListFetch event,
    Emitter<ListState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      if (state.status == ListStatus.initial) {
        final posts = await _fetchListItems(emit: emit, product: state.product);

        return emit(
          state.copyWith(
            status: ListStatus.success,
            variants: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts = await _fetchListItems(emit: emit, startIndex: state.variants.length, product: state.product);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ListStatus.success,
                variants: List.of(state.variants)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: ListStatus.failure));
    }
  }

  Future<List<VariantListItem>> _fetchListItems(
      {required Emitter<ListState> emit, int startIndex = 0, int product = 0}) async {
    DualResult? response =
        await instance.variants.list(product: product, offset: startIndex, limit: _postLimit, param: state.param);

    emit(state.copyWith(total: response?.model2));

    if (product > 0 && response?.model3 != null) {
      emit(state.copyWith(productName: response?.model3));
    }

    if (response?.status == Protocol.empty) {
      return List<VariantListItem>.empty();
    }

    if (response?.model.isEmpty) {
      return List<VariantListItem>.empty();
    }

    return response?.model.toList();
  }
}
