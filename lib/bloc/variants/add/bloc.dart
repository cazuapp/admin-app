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

import 'package:cazuapp_admin/bloc/variants/add/state.dart';
import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/validators/image.dart';
import 'package:cazuapp_admin/validators/product.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:cazuapp_admin/validators/price.dart';
import 'package:cazuapp_admin/validators/text.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';
import '../../../validators/name.dart';

part 'event.dart';

class VariantAddBloc extends Bloc<VariantAddEvent, VariantAddState> {
  final AppInstance instance;

  VariantAddBloc({required this.instance}) : super(const VariantAddState.initial()) {
    on<TitleChanged>(_onTitleChanged);
    on<PriceChanged>(_onPriceChanged);
    on<VariantOK>(_onOK);
    on<SetProduct>(onSetProduct);

    on<VariantAddSubmitted>(_onSubmitted);
    on<SetImage>(onSetImage);
  }

  Future<void> onSetImage(SetImage event, Emitter<VariantAddState> emit) async {
    final image = Image.pure(event.path);

    emit(state.copyWith(image: image.value));

    emit(state.copyWith(
        isValid: Formz.validate(
            [Product.dirty(state.product), Name.dirty(state.model.title), Price.dirty(state.model.price), image])));
  }

  Future<void> onSetProduct(SetProduct event, Emitter<VariantAddState> emit) async {
    final productName = event.productName;
    final product = Product.pure(event.product);

    emit(state.copyWith(product: product.value, productName: productName));
    emit(state.copyWith(
        isValid: Formz.validate(
            [Name.dirty(state.model.title), product, Image.dirty(state.image), Price.dirty(state.model.price)])));
  }

  Future<void> _onOK(VariantOK event, Emitter<VariantAddState> emit) async {
    final collection = state.model;

    emit(const VariantAddState.initial());
    emit(state.copyWith(model: collection));
  }

  Future<void> _onPriceChanged(PriceChanged event, Emitter<VariantAddState> emit) async {
    final price = Price.pure(event.price);

    emit(state.copyWith(model: state.model.copyWith(price: price.value)));
    emit(state.copyWith(
        isValid: Formz.validate(
            [price, Name.dirty(state.model.title), Product.dirty(state.product), Image.dirty(state.image)])));
  }

  Future<void> _onTitleChanged(TitleChanged event, Emitter<VariantAddState> emit) async {
    final title = Name.dirty(event.title);
    final product = Product.dirty(state.product);

    emit(state.copyWith(model: state.model.copyWith(title: title.value)));
    emit(state.copyWith(
        isValid: Formz.validate([title, Text.dirty(state.model.title), product, Price.dirty(state.model.price)])));
  }

  Future<void> _onSubmitted(VariantAddSubmitted event, Emitter<VariantAddState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      String? errmsg = "Error while processing request";

      try {
        DualResult? result = await instance.variants
            .add(title: state.model.title, product: state.product, price: state.model.price, image: state.image);

        if (result?.status == Protocol.ok) {
          log("Adding new variant ${result?.model2}");

          emit(state.copyWith(result: result?.status, id: result?.model2, status: FormzSubmissionStatus.success));
        } else {
          switch (result?.status) {
            case Protocol.exists:
              errmsg = "Variant already exists";
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
