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

enum CollectionSearchStatus { loading, initial, success, failure }

class CollectionSearchState extends Equatable {
  final CollectionSearchStatus status;
  final bool hasReachedMax;
  final List<Collection> collections;
  final int total;
  final String text;
  final Param param;
  final bool pick;

  const CollectionSearchState(
      {this.status = CollectionSearchStatus.initial,
      this.hasReachedMax = false,
      this.collections = const <Collection>[],
      this.total = 0,
      this.pick = false,
      this.text = '',
      this.param = Param.all});

  CollectionSearchState copyWith({
    String? text,
    Param? param,
    int? product,
    bool? pick,
    CollectionSearchStatus? status,
    int? total,
    List<Collection>? collections,
    bool? hasReachedMax,
  }) {
    return CollectionSearchState(
        param: param ?? this.param,
        pick: pick ?? this.pick,
        text: text ?? this.text,
        status: status ?? this.status,
        total: total ?? this.total,
        collections: collections ?? this.collections,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    return '''VariantSearchStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, collections, total, hasReachedMax, text, param, pick];
}
