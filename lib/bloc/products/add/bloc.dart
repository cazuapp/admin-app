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

import 'package:cazuapp_admin/bloc/products/add/state.dart';
import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/models/product.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:cazuapp_admin/validators/collection.dart';
import 'package:cazuapp_admin/validators/piority.dart';
import 'package:cazuapp_admin/validators/text.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';
import '../../../validators/name.dart';

part 'event.dart';

class ProductAddBloc extends Bloc<ProductAddEvent, ProductAddState> {
  final AppInstance instance;

  ProductAddBloc({required this.instance}) : super(const ProductAddState.initial()) {
    on<ProductNameChanged>(_onNameChanged);
    on<ProductDescriptionChanged>(_onDescriptionChanged);
    on<ProductPiorityChanged>(_onPiorityChanged);

    on<ProductAddSubmitted>(_onSubmitted);
    on<ProductOK>(_onOK);
    on<SetCollection>(onSetCollection);
  }

  Future<void> _onOK(ProductOK event, Emitter<ProductAddState> emit) async {
    final product = state.model;

    emit(const ProductAddState.initial());
    emit(state.copyWith(model: product));
  }

  Future<void> onSetCollection(SetCollection event, Emitter<ProductAddState> emit) async {
    final collectionName = event.collectionName;
    final collection = Collection.dirty(event.collection);

    emit(state.copyWith(collection: event.collection, collectionName: collectionName));

    emit(state.copyWith(
        isValid: Formz.validate([
      Piority.dirty(state.model.piority),
      Text.dirty(state.model.description),
      Name.dirty(state.model.name),
      collection
    ])));
  }


  Future<void> _onPiorityChanged(ProductPiorityChanged event, Emitter<ProductAddState> emit) async {
    final piority = Piority.dirty(event.piority);

    emit(state.copyWith(model: state.model.copyWith(piority: piority.value)));

    emit(state.copyWith(
        isValid: Formz.validate([
      piority,
      Text.dirty(state.model.description),
      Name.dirty(state.model.name),
      Collection.dirty(state.collection)
    ])));
  }

  Future<void> _onNameChanged(ProductNameChanged event, Emitter<ProductAddState> emit) async {
final name = Name.dirty(event.name);

    emit(state.copyWith(
        model: state.model.copyWith(name: name.value),
        isValid: Formz.validate([
          name,
          Text.dirty(state.model.description),
          Piority.dirty(state.model.piority),
          Collection.dirty(state.collection),
        ])));
  }

  Future<void> _onDescriptionChanged(ProductDescriptionChanged event, Emitter<ProductAddState> emit) async {
    final description = Text.dirty(event.description);

    emit(state.copyWith(model: state.model.copyWith(description: description.value)));
    emit(state.copyWith(
        isValid: Formz.validate([
      description,
      Name.dirty(state.model.name),
      Text.dirty(state.model.description),
      Piority.dirty(state.model.piority),
      Collection.dirty(state.collection),
    ])));
  }

  Future<void> _onSubmitted(ProductAddSubmitted event, Emitter<ProductAddState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      String? errmsg = "Error while processing request";

      try {
        DualResult? result = await instance.products.add(
          name: state.model.name,
          piority: state.model.piority,
          description: state.model.description,
          collection: state.collection,
        );

        if (result?.status == Protocol.ok) {
          emit(state.copyWith(result: result?.status, id: result?.model2, status: FormzSubmissionStatus.success));
        } else {
          switch (result?.status) {
            case Protocol.exists:
              errmsg = "Product already exists";
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
