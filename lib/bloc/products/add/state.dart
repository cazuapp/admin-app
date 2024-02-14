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
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';

class ProductAddState extends Equatable {
  const ProductAddState({
    this.id = 0,
    this.model = const Product.initial(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errmsg = "",
    this.result = Protocol.empty,
    this.collection = 0,
    this.collectionName = "",
  });

  const ProductAddState.initial()
      : this(
            status: FormzSubmissionStatus.initial,
            result: Protocol.empty,
            isValid: false,
            id: 0,
            collection: 0,
            collectionName: "",
            model: const Product.initial());

  final int result;
  final int id;
  final int collection;
  final String collectionName;
  final Product model;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String errmsg;

  ProductAddState copyWith({
    int? result,
    int? id,
    FormzSubmissionStatus? status,
    Product? model,
    bool? isValid,
    String? errmsg,
    String? image,
    int? collection,
    String? collectionName,
  }) {
    return ProductAddState(
        id: id ?? this.id,
        collection: collection ?? this.collection,
        collectionName: collectionName ?? this.collectionName,
        errmsg: errmsg ?? this.errmsg,
        model: model ?? this.model,
        result: result ?? this.result,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [id, errmsg, model, result, status, isValid, collection, collectionName];
}
