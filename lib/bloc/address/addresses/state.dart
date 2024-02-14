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

enum AddressStatus { initial, success, failure }

class AddressState extends Equatable {
  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const <Address>[],
    this.hasReachedMax = false,
    this.userid = 0,
    this.total = 0,
  });

  final AddressStatus status;
  final List<Address> addresses;
  final bool hasReachedMax;
  final int userid;
  final int total;

  AddressState copyWith({
    int? userid,
    int? total,
    AddressStatus? status,
    List<Address>? addresses,
    bool? hasReachedMax,
  }) {
    return AddressState(
      userid: userid ?? this.userid,
      total: total ?? this.total,
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AddressState { status: $status, hasReachedMax: $hasReachedMax, posts: ${addresses.length} }''';
  }

  @override
  List<Object> get props => [status, addresses, total, hasReachedMax];
}
