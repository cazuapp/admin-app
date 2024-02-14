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

abstract class CollectionUpdateEvent extends Equatable {
  const CollectionUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateBlocKeyChanged extends CollectionUpdateEvent {
  const UpdateBlocKeyChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class AddressInfoEventOK extends CollectionUpdateEvent {
  const AddressInfoEventOK();

  @override
  List<Object> get props => [];
}

class ManagerPreload extends CollectionUpdateEvent {
  const ManagerPreload({required this.id, required this.key, required this.value});

  final int id;
  final String key;
  final String value;

  @override
  List<Object> get props => [id, key, value];
}

class CleanErr extends CollectionUpdateEvent {
  const CleanErr();

  @override
  List<Object> get props => [];
}

class UpdateSubmitted extends CollectionUpdateEvent {
  const UpdateSubmitted();
}
