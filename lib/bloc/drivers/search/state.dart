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

enum DriverSearchStatus { loading, initial, success, failure }

class DriverSearchState extends Equatable {
  final DriverSearchStatus status;
  final bool hasReachedMax;
  final List<User> users;
  final int total;
  final String text;
  final Param param;
  final bool pick;

  const DriverSearchState({
    this.status = DriverSearchStatus.initial,
    this.hasReachedMax = false,
    this.users = const <User>[],
    this.total = 0,
    this.text = '',
    this.param = Param.all,
    this.pick = false,
  });

  DriverSearchState copyWith({
    String? text,
    Param? param,
    DriverSearchStatus? status,
    int? total,
    List<User>? users,
    bool? hasReachedMax,
    bool? pick,
  }) {
    return DriverSearchState(
      param: param ?? this.param,
      text: text ?? this.text,
      status: status ?? this.status,
      total: total ?? this.total,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pick: pick ?? this.pick,
    );
  }

  @override
  String toString() {
    return '''DriverSearchStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, users, total, hasReachedMax, text, param, pick];
}
