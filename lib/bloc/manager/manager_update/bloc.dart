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

class ManagerUpdateBloc extends Bloc<ManagerInfoEvent, ManagerUpdateState> {
  final AppInstance instance;

  ManagerUpdateBloc({required this.instance}) : super(const ManagerUpdateState.initial()) {
    on<AddressUpdateBlocKeyChanged>(_onKeyChanged);

    on<AddressInfoEventOK>(_onOK);
    on<AddresssInfoSubmitted>(_onSubmitted);
    on<ManagerPreload>(_onPreload);
  }

  Future<void> _onPreload(ManagerPreload event, Emitter<ManagerUpdateState> emit) async {
    final key = event.key;
    final value = event.value;

    emit(state.copyWith(key: key, value: value, isValid: false));
  }

  void _onOK(AddressInfoEventOK event, Emitter<ManagerUpdateState> emit) {
    emit(const ManagerUpdateState.initial());
  }

  void _onKeyChanged(AddressUpdateBlocKeyChanged event, Emitter<ManagerUpdateState> emit) {
    final key = state.key;
    final value = Name.dirty(event.value);

    emit(state.copyWith(key: key, finalvalue: value.value, isValid: Formz.validate([value])));
  }

  Future<void> _onSubmitted(AddresssInfoSubmitted event, Emitter<ManagerUpdateState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        if (state.finalvalue == "") {
          emit(state.copyWith(result: Protocol.ok, value: state.value, status: FormzSubmissionStatus.success));
          return;
        }

        int? result = await instance.settings.set(key: state.key, value: state.finalvalue);

        String errmsg = "Error while processing request";

        if (result == Protocol.ok) {
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
          emit(state.copyWith(result: result, status: FormzSubmissionStatus.success));
        } else {
          emit(state.copyWith(result: result, errmsg: errmsg, status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(result: Protocol.unknownError, status: FormzSubmissionStatus.failure));
      }
    }
  }
}
