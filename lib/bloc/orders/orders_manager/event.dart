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

abstract class OrderManagerEvent extends Equatable {
  const OrderManagerEvent();
}

class OrderCancelEventOK extends OrderManagerEvent {
  const OrderCancelEventOK();

  @override
  List<Object> get props => [];
}

class GetAllUser extends OrderManagerEvent {
  const GetAllUser({required this.id});
  final int id;

  @override
  List<Object> get props => [id];
}

class OrderCancelRequest extends OrderManagerEvent {
  const OrderCancelRequest({required this.userid, required this.id});

  final int id;
  final int userid;

  @override
  List<Object> get props => [id, userid];
}

class OrderInfoRequest extends OrderManagerEvent {
  const OrderInfoRequest({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}
