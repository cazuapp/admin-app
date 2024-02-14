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

enum ListStatus { loading, initial, success, failure }

class ListState extends Equatable {
  final ListStatus status;
  final bool hasReachedMax;
  final List<Collection> collections;
  final Param param;
  final int total;
  final String text;
  final bool pick;

  const ListState({
    this.status = ListStatus.initial,
    this.hasReachedMax = false,
    this.total = 0,
    this.pick = false,
    this.collections = const <Collection>[],
    this.param = Param.pending,
    this.text = "",
  });

  ListState copyWith({
    ListStatus? status,
    String? text,
    bool? pick,
    int? total,
    List<Collection>? collections,
    bool? hasReachedMax,
    Param? param,
  }) {
    return ListState(
      param: param ?? this.param,
      pick: pick ?? this.pick,
      total: total ?? this.total,
      text: text ?? this.text,
      status: status ?? this.status,
      collections: collections ?? this.collections,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ListStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, collections, hasReachedMax, param, total, text, pick];
}
