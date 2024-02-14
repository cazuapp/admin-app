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

enum CollectionInfoStatus { initial, loading, success, failure, deleted }

class CollectionInfoState extends Equatable {
  const CollectionInfoState(
      {required this.id, this.status = CollectionInfoStatus.initial, this.errmsg = "", required this.collection});

  const CollectionInfoState.initial()
      : this(id: 0, status: CollectionInfoStatus.initial, collection: const Collection.initial());

  final Collection collection;
  final CollectionInfoStatus status;
  final int id;
  final String errmsg;

  CollectionInfoState copyWith({int? id, Collection? collection, CollectionInfoStatus? status, String? errmsg}) {
    return CollectionInfoState(
      id: id ?? this.id,
      errmsg: errmsg ?? this.errmsg,
      collection: collection ?? this.collection,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [id, collection, status];
}
