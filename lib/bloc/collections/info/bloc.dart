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

import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/models/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/dual.dart';

import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class CollectionInfoBloc extends Bloc<CollectionInfoEvent, CollectionInfoState> {
  final AppInstance instance;

  CollectionInfoBloc({required this.instance}) : super(const CollectionInfoState.initial()) {
    on<CollectionInfoEventOK>(_onOK);
    on<FetchInfo>(_onFetchInfo);
    on<DeleteCollection>(_onDeleteCollection);
  }

  Future<void> _onOK(CollectionInfoEventOK event, Emitter<CollectionInfoState> emit) async {
    emit(const CollectionInfoState.initial());
  }

  Future<void> _onFetchInfo(FetchInfo event, Emitter<CollectionInfoState> emit) async {
    final id = event.id;

    emit(state.copyWith(status: CollectionInfoStatus.loading, id: id));

    try {
      DualResult? result = await instance.collections.info(id: state.id);
      emit(state.copyWith(status: CollectionInfoStatus.success, collection: result?.model));
    } catch (_) {
      emit(state.copyWith(status: CollectionInfoStatus.failure));
    }
  }

  Future<void> _onDeleteCollection(DeleteCollection event, Emitter<CollectionInfoState> emit) async {
    final idx = event.id;

    emit(state.copyWith(status: CollectionInfoStatus.loading));

    try {
      int? result = await instance.collections.delete(id: idx);

      if (result == Protocol.ok) {
        emit(state.copyWith(status: CollectionInfoStatus.deleted));
      } else {
        String? errmsg = "";

        switch (result) {
          case Protocol.notFound:
            errmsg = "Collection not found";
            break;

          case Protocol.hasOffspring:
            errmsg = "Has products.";
            break;
          default:
            errmsg = "Unable to remove";
        }

        emit(state.copyWith(status: CollectionInfoStatus.failure, errmsg: errmsg));
      }
    } catch (_) {
      emit(state.copyWith(status: CollectionInfoStatus.failure));
    }
  }
}
