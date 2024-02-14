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

class VariantSearchBloc extends Bloc<VariantSearchEvent, VariantSearchState> {
  AppInstance instance;

  VariantSearchBloc({required this.instance}) : super(const VariantSearchState()) {
    on<SetParam>(_onSetParam);

    on<SearchRequest>(
      _onSearchRequest,
      transformer: throttleDroppable(throttleDuration),
    );

    on<OnScroll>(_onScroll);
    on<SetProduct>(_onSetProduct);

    on<SearchReset>(_onSearchReset);
    on<Init>(_onInit);
  }

  Future<void> _onSetProduct(
    SetProduct event,
    Emitter<VariantSearchState> emit,
  ) async {
    final product = event.product;
    return emit(state.copyWith(product: product));
  }

  Future<void> _onScroll(
    OnScroll event,
    Emitter<VariantSearchState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    await _onSearchRequest(SearchRequest(text: state.text), emit);
  }

  Future<void> _onInit(
    Init event,
    Emitter<VariantSearchState> emit,
  ) async {
    final query = state.text;

    emit(state.copyWith(text: query));
  }

  Future<void> _onSetParam(
    SetParam event,
    Emitter<VariantSearchState> emit,
  ) async {
    final change = event.param;

    emit(state.copyWith(param: change));
  }

  Future<void> _onSearchReset(
    SearchReset event,
    Emitter<VariantSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        total: 0,
        text: "",
        status: VariantSearchStatus.success,
        variants: <VariantListItem>[],
        hasReachedMax: false,
      ),
    );
  }

  Future<void> _onSearchRequest(SearchRequest event, Emitter<VariantSearchState> emit) async {
    final text = event.text;
    if (state.hasReachedMax) return;

    emit(state.copyWith(text: text));

    if (state.hasReachedMax) return;

    try {
      if (state.status == VariantSearchStatus.initial) {
        return emit(state.copyWith(status: VariantSearchStatus.success));
      }

      final posts = await _fetchResults(emit: emit, startIndex: state.variants.length, product: state.product);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: VariantSearchStatus.success))
          : emit(
              state.copyWith(
                status: VariantSearchStatus.success,
                variants: List.of(state.variants)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: VariantSearchStatus.failure));
    }
  }

  Future<List<VariantListItem>> _fetchResults(
      {required Emitter<VariantSearchState> emit, int startIndex = 0, int product = 0}) async {
    DualResult? response = await instance.variants
        .search(text: state.text, offset: startIndex, limit: _postLimit, param: state.param, product: product);

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
