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

enum UserListStatus { loading, initial, success, failure }

class UserListState extends Equatable {
  final UserListStatus status;
  final bool hasReachedMax;
  final List<User> users;
  final int total;
  final String text;

  const UserListState({
    this.status = UserListStatus.initial,
    this.hasReachedMax = false,
    this.total = 0,
    this.users = const <User>[],
    this.text = "",
  });

  UserListState copyWith({
    UserListStatus? status,
    String? text,
    List<User>? users,
    bool? hasReachedMax,
    int? total,
  }) {
    return UserListState(
      text: text ?? this.text,
      total: total ?? this.total,
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''UserListStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, users, hasReachedMax, total, text];
}
