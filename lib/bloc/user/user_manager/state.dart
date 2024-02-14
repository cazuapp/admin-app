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

enum UserStatus { initial, loading, success, failure }

class UserManagerState extends Equatable {
  const UserManagerState(
      {required this.user,
      required this.errmsg,
      this.available = false,
      required this.status,
      required this.ban,
      this.current = UserStatus.initial,
      this.radio = BanCodeStatus.noban});

  UserManagerState.initial()
      : this(
            available: false,
            status: Protocol.empty,
            errmsg: "",
            user: UserExtend.initial(),
            ban: const BanListItem.initial());

  final UserExtend user;
  final int status;
  final UserStatus current;
  final String errmsg;
  final BanListItem ban;
  final BanCodeStatus radio;
  final bool available;

  UserManagerState copyWith(
      {UserExtend? user,
      int? status,
      String? errmsg,
      required current,
      BanListItem? ban,
      BanCodeStatus? radio,
      bool? available}) {
    return UserManagerState(
        errmsg: errmsg ?? this.errmsg,
        user: user ?? this.user,
        ban: ban ?? this.ban,
        radio: radio ?? this.radio,
        available: available ?? this.available,
        status: status ?? this.status,
        current: current ?? this.current);
  }

  @override
  List<Object> get props => [user, errmsg, current, ban, radio, status, available];
}
