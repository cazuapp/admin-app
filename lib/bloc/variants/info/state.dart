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

enum VariantInfoStatus { initial, loading, success, failure, deleted }

class VariantInfoState extends Equatable {
  const VariantInfoState(
      {required this.id, required this.variant, required this.errmsg, this.status = VariantInfoStatus.initial});

  const VariantInfoState.initial()
      : this(id: 0, status: VariantInfoStatus.initial, errmsg: "", variant: const Variant.initial());

  final Variant variant;
  final VariantInfoStatus status;
  final int id;
  final String errmsg;

  VariantInfoState copyWith({int? id, Variant? variant, VariantInfoStatus? status, String? errmsg}) {
    return VariantInfoState(
        id: id ?? this.id,
        variant: variant ?? this.variant,
        status: status ?? this.status,
        errmsg: errmsg ?? this.errmsg);
  }

  @override
  List<Object> get props => [variant, id, status, errmsg];
}
