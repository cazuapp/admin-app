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

part of 'bloc.dart';

class ProductUpdateState extends Equatable {
  final FormzSubmissionStatus status;
  final int id;
  final String key;
  final String value;
  final String finalvalue;
  final String errmsg;
  final bool isValid;
  final int result;

  const ProductUpdateState({
    this.id = 0,
    this.key = "",
    this.value = "",
    this.errmsg = "",
    this.finalvalue = "",
    this.result = Protocol.empty,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  const ProductUpdateState.initial()
      : this(
          id: 0,
          key: "",
          value: "",
          errmsg: "",
          finalvalue: "",
          result: Protocol.empty,
          status: FormzSubmissionStatus.initial,
          isValid: false,
        );

  ProductUpdateState copyWith({
    int? result,
    int? id,
    FormzSubmissionStatus? status,
    String? key,
    String? errmsg,
    String? value,
    String? finalvalue,
    bool? isValid,
  }) {
    return ProductUpdateState(
        id: id ?? this.id,
        result: result ?? this.result,
        key: key ?? this.key,
        errmsg: errmsg ?? this.errmsg,
        value: value ?? this.value,
        finalvalue: finalvalue ?? this.finalvalue,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [key, errmsg, value, status, finalvalue];
}
