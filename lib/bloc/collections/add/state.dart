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

import 'package:cazuapp_admin/models/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';

class CollectionAddState extends Equatable {
  const CollectionAddState(
      {this.id = 0,
      this.model = const Collection.initial(),
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errmsg = "",
      this.image = "",
      this.result = Protocol.empty});

  const CollectionAddState.initial()
      : this(
            id: 0,
            status: FormzSubmissionStatus.initial,
            result: Protocol.empty,
            isValid: false,
            image: "",
            model: const Collection(title: "", imagesrc: "", piority: 0, id: 0, created: ""));

  final int result;
  final Collection model;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String errmsg;
  final int id;
  final String image;

  CollectionAddState copyWith({
    int? id,
    int? result,
    FormzSubmissionStatus? status,
    Collection? model,
    bool? isValid,
    String? image,
    String? errmsg,
  }) {
    return CollectionAddState(
        id: id ?? this.id,
        errmsg: errmsg ?? this.errmsg,
        model: model ?? this.model,
        result: result ?? this.result,
        image: image ?? this.image,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [errmsg, model, result, status, isValid, id, image];
}
