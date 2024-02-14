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

import 'package:cazuapp_admin/models/variant.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';

class VariantAddState extends Equatable {
  const VariantAddState(
      {this.id = 0,
      this.model = const Variant.initial(),
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errmsg = "",
      this.result = Protocol.empty,
      this.product = 0,
      this.image = "",
      this.productName = ""});

  const VariantAddState.initial()
      : this(
            id: 0,
            status: FormzSubmissionStatus.initial,
            result: Protocol.empty,
            isValid: false,
            product: 0,
            image: "",
            productName: "",
            model: const Variant(stock: 0, id: 0, title: "", price: 0.0, productID: 0));

  final int result;
  final Variant model;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String errmsg;
  final int id;
  final int product;
  final String productName;
  final String image;

  VariantAddState copyWith({
    int? id,
    int? product,
    int? result,
    FormzSubmissionStatus? status,
    Variant? model,
    String? image,
    bool? isValid,
    String? errmsg,
    String? productName,
  }) {
    return VariantAddState(
        id: id ?? this.id,
        image: image ?? this.image,
        errmsg: errmsg ?? this.errmsg,
        model: model ?? this.model,
        result: result ?? this.result,
        status: status ?? this.status,
        productName: productName ?? this.productName,
        product: product ?? this.product,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [errmsg, model, result, status, isValid, id, productName, product, image];
}
