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

import 'package:cazuapp_admin/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dual.dart';

import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class ProductInfoBloc extends Bloc<ProductInfoEvent, ProductInfoState> {
  final AppInstance instance;

  ProductInfoBloc({required this.instance}) : super(const ProductInfoState.initial()) {
    on<ProductInfoEventOK>(_onOK);
    on<FetchInfo>(_onFetchInfo);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateProduct>(_onUpdate);
  }

  Future<void> _onUpdate(UpdateProduct event, Emitter<ProductInfoState> emit) async {
    final key = event.key;
    final id = event.id;
    final value = event.value;

    emit(state.copyWith(status: ProductInfoStatus.loading));

    try {
      int? result = await instance.products.update(id: id, key: key, value: value);

      if (result == Protocol.ok) {
        emit(state.copyWith(status: ProductInfoStatus.success));
      } else {
        String? errmsg = "";

        switch (result) {
          case Protocol.notFound:
            errmsg = "Item not found.";
            break;

          default:
            errmsg = "Unable to update";
        }

        emit(state.copyWith(status: ProductInfoStatus.failure, errmsg: errmsg));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductInfoStatus.failure));
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductInfoState> emit) async {
    final idx = event.id;

    emit(state.copyWith(status: ProductInfoStatus.loading));

    try {
      int? result = await instance.products.delete(id: idx);

      if (result == Protocol.ok) {
        emit(state.copyWith(status: ProductInfoStatus.deleted));
      } else {
        String? errmsg = "";

        switch (result) {
          case Protocol.notFound:
            errmsg = "Product not found";
            break;

          default:
            errmsg = "Closure failure";
        }

        emit(state.copyWith(status: ProductInfoStatus.failure, errmsg: errmsg));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductInfoStatus.failure));
    }
  }

  Future<void> _onOK(ProductInfoEventOK event, Emitter<ProductInfoState> emit) async {
    emit(const ProductInfoState.initial());
  }

  Future<void> _onFetchInfo(FetchInfo event, Emitter<ProductInfoState> emit) async {
    final id = event.id;

    emit(state.copyWith(status: ProductInfoStatus.loading, id: id));

    try {
      DualResult? result = await instance.products.info(id: state.id);

      emit(state.copyWith(status: ProductInfoStatus.success, product: result?.model));
    } catch (_) {
      emit(state.copyWith(status: ProductInfoStatus.failure));
    }
  }
}
