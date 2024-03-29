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

abstract class AddressInfoEvent extends Equatable {
  const AddressInfoEvent();

  @override
  List<Object> get props => [];
}

class AddressUpdateBlocKeyChanged extends AddressInfoEvent {
  const AddressUpdateBlocKeyChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class AddressInfoEventOK extends AddressInfoEvent {
  const AddressInfoEventOK();

  @override
  List<Object> get props => [];
}

class AddresssInfoSubmitted extends AddressInfoEvent {
  const AddresssInfoSubmitted();
}

class SetData extends AddressInfoEvent {
  const SetData(
      {required this.key,
      required this.value,
      required this.iconsrc,
      required this.user,
      required this.id,
      required this.title});

  final LocalKeyEvent key;
  final String value;
  final IconData iconsrc;
  final int id;
  final int user;
  final String title;

  @override
  List<Object> get props => [key, value, iconsrc, id, user, title];
}

class AddressProgress extends AddressInfoEvent {
  const AddressProgress({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}
