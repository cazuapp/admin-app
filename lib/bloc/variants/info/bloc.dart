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

import 'dart:developer';

import 'package:cazuapp_admin/models/variant.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dual.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class VariantInfoBloc extends Bloc<VariantInfoEvent, VariantInfoState> {
  final AppInstance instance;

  VariantInfoBloc({required this.instance}) : super(const VariantInfoState.initial()) {
    on<EventOK>(_onOK);
    on<Info>(_onFetchInfo);
  }

  Future<void> _onOK(EventOK event, Emitter<VariantInfoState> emit) async {
    emit(const VariantInfoState.initial());
  }

  Future<void> _onFetchInfo(Info event, Emitter<VariantInfoState> emit) async {
    final id = event.id;
    log("Fetching information on variant $id");

    emit(state.copyWith(status: VariantInfoStatus.loading, id: id));

    try {
      DualResult? result = await instance.variants.info(id: state.id);

      emit(state.copyWith(status: VariantInfoStatus.success, variant: result?.model));
    } catch (_) {
      emit(state.copyWith(status: VariantInfoStatus.failure));
    }
  }
}
