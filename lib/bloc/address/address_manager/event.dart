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

abstract class AddressFetchEvent extends Equatable {
  const AddressFetchEvent();
}

class AddressAddressRequest extends AddressFetchEvent {
  const AddressAddressRequest();

  @override
  List<Object> get props => [];
}

class AddressDelete extends AddressFetchEvent {
  const AddressDelete({required this.id, required this.user});

  final int id;
  final int user;

  @override
  List<Object> get props => [id, user];
}

class SetBase extends AddressFetchEvent {
  const SetBase({required this.id, required this.user, required this.name});

  final int id;
  final int user;
  final String name;

  @override
  List<Object> get props => [id, user, name];
}

class AddressManagerOK extends AddressFetchEvent {
  const AddressManagerOK();

  @override
  List<Object> get props => [];
}
