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

import 'package:cazuapp_admin/bloc/collections/add/state.dart';
import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/models/collection.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:cazuapp_admin/validators/image.dart';
import 'package:cazuapp_admin/validators/piority.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';
import '../../../validators/name.dart';

part 'event.dart';

class CollectionAddBloc extends Bloc<CollectionAddEvent, CollectionAddState> {
  final AppInstance instance;

  CollectionAddBloc({required this.instance}) : super(const CollectionAddState.initial()) {
    on<CollectionTitleChanged>(_onTitleChanged);
    on<CollectionPiorityChanged>(_onPiorityChanged);
    on<CollectionOK>(_onOK);

    on<CollectionAddSubmitted>(_onSubmitted);
    on<SetImage>(onSetImage);
  }

  Future<void> onSetImage(SetImage event, Emitter<CollectionAddState> emit) async {
    final image = Image.pure(event.path);

    emit(state.copyWith(image: image.value));

    emit(state.copyWith(
        isValid: Formz.validate([Piority.dirty(state.model.piority), Name.dirty(state.model.title), image])));
  }

  Future<void> _onOK(CollectionOK event, Emitter<CollectionAddState> emit) async {
    final collection = state.model;
    final image = state.image;

    emit(const CollectionAddState.initial());
    emit(state.copyWith(model: collection, image: image));
  }

  Future<void> _onPiorityChanged(CollectionPiorityChanged event, Emitter<CollectionAddState> emit) async {
    final piority = Piority.dirty(event.piority);

    emit(state.copyWith(model: state.model.copyWith(piority: piority.value)));
    emit(state.copyWith(isValid: Formz.validate([Image.dirty(state.image), Name.dirty(state.model.title), piority])));
  }

  Future<void> _onTitleChanged(CollectionTitleChanged event, Emitter<CollectionAddState> emit) async {
    final title = Name.dirty(event.title);

    emit(state.copyWith(model: state.model.copyWith(title: title.value)));
    emit(
        state.copyWith(isValid: Formz.validate([Image.dirty(state.image), title, Piority.dirty(state.model.piority)])));
  }

  Future<void> _onSubmitted(CollectionAddSubmitted event, Emitter<CollectionAddState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      String? errmsg = "Error while processing request";

      try {
        DualResult? result =
            await instance.collections.add(title: state.model.title, image: state.image, piority: state.model.piority);

        if (result?.status == Protocol.ok) {
          emit(state.copyWith(result: result?.status, id: result?.model2, status: FormzSubmissionStatus.success));
        } else {
          switch (result?.status) {
            case Protocol.exists:
              errmsg = "Collection already exists";
              break;

            default:
              errmsg = "An error has occured";
              break;
          }

          emit(state.copyWith(result: result?.status, errmsg: errmsg, status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(result: Protocol.unknownError, status: FormzSubmissionStatus.failure));
      }
    }
  }
}
