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

enum AddressStatus { initial, loading, success, failure }

class AddressManagerState extends Equatable {
  const AddressManagerState(
      {required this.address,
      required this.errmsg,
      required this.status,
      this.current = AddressStatus.initial,
      required this.id,
      required this.user,
      required this.name});

  const AddressManagerState.initial()
      : this(id: 0, user: 0, name: "", status: Protocol.empty, errmsg: "", address: const Address.initial());

  final int id;
  final int user;
  final String name;
  final Address address;
  final int status;
  final AddressStatus current;
  final String errmsg;

  AddressManagerState copyWith(
      {Address? address, int? id, int? user, String? name, int? status, String? errmsg, required current}) {
    return AddressManagerState(
        id: id ?? this.id,
        user: user ?? this.user,
        name: name ?? this.name,
        errmsg: errmsg ?? this.errmsg,
        address: address ?? this.address,
        status: status ?? this.status,
        current: current ?? this.current);
  }

  @override
  List<Object> get props => [address, errmsg, current, id, user, name];
}
