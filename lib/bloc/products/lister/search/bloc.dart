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
import 'package:cazuapp_admin/models/product_list.dart';
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

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  AppInstance instance;

  ProductSearchBloc({required this.instance}) : super(const ProductSearchState()) {
    on<SetParam>(_onSetParam);

    on<SearchRequest>(
      _onSearchRequest,
      transformer: throttleDroppable(throttleDuration),
    );

    on<OnScroll>(_onScroll);
    on<SetCollection>(_onSetCollection);
    on<SetPick>(onSetPick);

    on<SearchReset>(_onSearchReset);
    on<Init>(_onInit);
  }

  Future<void> _onSetCollection(
    SetCollection event,
    Emitter<ProductSearchState> emit,
  ) async {
    final collection = event.collection;
    return emit(state.copyWith(collection: collection));
  }

  Future<void> onSetPick(
    SetPick event,
    Emitter<ProductSearchState> emit,
  ) async {
    final pick = event.pick;
    return emit(state.copyWith(pick: pick));
  }

  Future<void> _onScroll(
    OnScroll event,
    Emitter<ProductSearchState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    await _onSearchRequest(SearchRequest(text: state.text), emit);
  }

  Future<void> _onInit(
    Init event,
    Emitter<ProductSearchState> emit,
  ) async {
    final query = state.text;

    emit(state.copyWith(text: query));
  }

  Future<void> _onSetParam(
    SetParam event,
    Emitter<ProductSearchState> emit,
  ) async {
    final change = event.param;

    emit(state.copyWith(param: change));
  }

  Future<void> _onSearchReset(
    SearchReset event,
    Emitter<ProductSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        total: 0,
        text: "",
        status: ProductSearchStatus.success,
        products: <ProductListItem>[],
        hasReachedMax: false,
      ),
    );
  }

  Future<void> _onSearchRequest(SearchRequest event, Emitter<ProductSearchState> emit) async {
    final text = event.text;
    if (state.hasReachedMax) return;

    emit(state.copyWith(text: text));

    if (state.hasReachedMax) return;

    try {
      if (state.status == ProductSearchStatus.initial) {
        return emit(state.copyWith(status: ProductSearchStatus.success));
      }

      final posts = await _fetchResults(emit: emit, startIndex: state.products.length, collection: state.collection);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: ProductSearchStatus.success))
          : emit(
              state.copyWith(
                status: ProductSearchStatus.success,
                products: List.of(state.products)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: ProductSearchStatus.failure));
    }
  }

  Future<List<ProductListItem>> _fetchResults(
      {required Emitter<ProductSearchState> emit, int startIndex = 0, int collection = 0}) async {
    DualResult? response = await instance.products
        .search(value: state.text, offset: startIndex, limit: _postLimit, collection: collection);

    emit(state.copyWith(total: response?.model2));

    if (response?.status == Protocol.empty) {
      return List<ProductListItem>.empty();
    }

    if (response?.model.isEmpty) {
      return List<ProductListItem>.empty();
    }

    return response?.model.toList();
  }
}
