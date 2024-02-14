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

enum DriverListStatus { loading, initial, success, failure }

class DriverListState extends Equatable {
  final DriverListStatus status;
  final bool hasReachedMax;
  final List<User> users;
  final int total;
  final String text;
  final bool pick;

  const DriverListState({
    this.status = DriverListStatus.initial,
    this.hasReachedMax = false,
    this.total = 0,
    this.users = const <User>[],
    this.text = "",
    this.pick = false,
  });

  DriverListState copyWith({
    DriverListStatus? status,
    String? text,
    List<User>? users,
    bool? hasReachedMax,
    int? total,
    bool? pick,
  }) {
    return DriverListState(
      text: text ?? this.text,
      total: total ?? this.total,
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pick: pick ?? this.pick,
    );
  }

  @override
  String toString() {
    return '''DriverListStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, users, hasReachedMax, total, text, pick];
}
