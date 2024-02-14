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

import 'package:formz/formz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/protocol.dart';
import '../../../validators/name.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class CollectionUpdateBloc extends Bloc<CollectionUpdateEvent, CollectionUpdateState> {
  final AppInstance instance;

  CollectionUpdateBloc({required this.instance}) : super(const CollectionUpdateState.initial()) {
    on<UpdateBlocKeyChanged>(_onKeyChanged);

    on<AddressInfoEventOK>(_onOK);
    on<UpdateSubmitted>(_onSubmitted);
    on<ManagerPreload>(_onPreload);
    on<CleanErr>(_cleanErr);
  }

  Future<void> _onPreload(ManagerPreload event, Emitter<CollectionUpdateState> emit) async {
    final id = event.id;
    final key = event.key;
    final value = event.value;

    emit(state.copyWith(id: id, key: key, value: value, isValid: false));
  }

  void _onOK(AddressInfoEventOK event, Emitter<CollectionUpdateState> emit) {
    emit(const CollectionUpdateState.initial());
  }

  void _cleanErr(CleanErr event, Emitter<CollectionUpdateState> emit) {
    emit(state.copyWith(errmsg: "", status: FormzSubmissionStatus.initial));
  }

  void _onKeyChanged(
      UpdateBlocKeyChanged event, Emitter<CollectionUpdateState> emit) {
    final key = state.key;
    final value = Name.dirty(event.value);

    emit(state.copyWith(key: key, finalvalue: value.value, isValid: Formz.validate([value])));
  }

  Future<void> _onSubmitted(
      UpdateSubmitted event, Emitter<CollectionUpdateState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        if (state.finalvalue == "") {
          emit(state.copyWith(result: Protocol.ok, value: state.value, status: FormzSubmissionStatus.success));
          return;
        }

        int? result = await instance.collections.update(
            id: state.id,
            key: state.key,
            value: state.key == "collection" ? int.parse(state.finalvalue) : state.finalvalue);

        String errmsg = "Error while processing request";

        if (result == Protocol.ok) {
          emit(state.copyWith(result: result, status: FormzSubmissionStatus.success));
        } else {
          switch (state.result as dynamic) {
            case Protocol.noChange:
              errmsg = "No change";
              break;

            case Protocol.noInternet:
              errmsg = "No internet.";
              break;

            default:
              errmsg = "Error occured";
              break;
          }
          emit(state.copyWith(result: result, errmsg: errmsg, status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(result: Protocol.unknownError, status: FormzSubmissionStatus.failure));
      }
    }
  }
}
