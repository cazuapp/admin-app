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

abstract class UserFetchEvent extends Equatable {
  const UserFetchEvent();
}

class UserInfoRequest extends UserFetchEvent {
  const UserInfoRequest(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class AssignOrder extends UserFetchEvent {
  const AssignOrder({required this.order, required this.user});

  final int order;
  final int user;

  @override
  List<Object> get props => [user, order];
}

class SetFlag extends UserFetchEvent {
  const SetFlag({required this.user, required this.status, required this.value});

  final int user;
  final bool status;
  final String value;

  @override
  List<Object> get props => [user, status, value];
}

class UserSetDriverStatus extends UserFetchEvent {
  const UserSetDriverStatus({required this.status});

  final bool status;

  @override
  List<Object> get props => [status];
}

class UserManagerOK extends UserFetchEvent {
  const UserManagerOK();

  @override
  List<Object> get props => [];
}

class UserManageDriver extends UserFetchEvent {
  const UserManageDriver({required this.status});

  final bool status;

  @override
  List<Object> get props => [status];
}

class UserManageHold extends UserFetchEvent {
  const UserManageHold({required this.type, required this.status});

  final bool status;
  final String type;

  @override
  List<Object> get props => [type, status];
}

class WhoAmi extends UserFetchEvent {
  const WhoAmi();

  @override
  List<Object> get props => [];
}

class Load extends UserFetchEvent {
  const Load();

  @override
  List<Object> get props => [];
}

class BanInfo extends UserFetchEvent {
  const BanInfo({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}

class SetBan extends UserFetchEvent {
  const SetBan({required this.id, required this.code});

  final int id;
  final BanCodeStatus code;

  @override
  List<Object> get props => [id, code];
}
