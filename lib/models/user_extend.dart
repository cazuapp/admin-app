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

import 'package:json_annotation/json_annotation.dart';

import '../components/etc.dart';

part 'user_extend.g.dart';

@JsonSerializable()
class UserExtend {
  final int id;

  late bool isDriver;

  final String email;

  final String first;

  final String last;

  late bool ableToOrder;

  late bool health;

  final bool verified;

  final String banCode;

  late bool driverStatus;

  final int favorites;

  final bool available;

  final int address;
  final String created;
  final bool rootFlags;
  final bool canManage;
  final bool canAssign;

  UserExtend(
      {required this.id,
      required this.available,
      required this.rootFlags,
      required this.canManage,
      required this.canAssign,
      required this.isDriver,
      required this.created,
      required this.favorites,
      required this.address,
      required this.driverStatus,
      required this.first,
      required this.banCode,
      required this.last,
      required this.email,
      required this.ableToOrder,
      required this.health,
      required this.verified});

  UserExtend.initial()
      : this(
            id: 0,
            rootFlags: false,
            canManage: false,
            canAssign: false,
            isDriver: false,
            available: false,
            created: "",
            first: "",
            last: "",
            favorites: 0,
            address: 0,
            driverStatus: false,
            email: "",
            verified: false,
            health: true,
            banCode: "noban",
            ableToOrder: true);

  factory UserExtend.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  UserExtend copyWith({
    bool? ableToOrder,
    bool? health,
    int? id,
    int? address,
    bool? rootFlags,
    bool? canManage,
    bool? canAssign,
    String? email,
    String? first,
    String? last,
    bool? isDriver,
    bool? available,
    int? favorites,
    bool? driverStatus,
    bool? verified,
    String? banCode,
  }) {
    return UserExtend(
        rootFlags: rootFlags ?? this.rootFlags,
        canManage: canManage ?? this.canManage,
        canAssign: canAssign ?? this.canAssign,
        available: available ?? this.available,
        created: created,
        driverStatus: driverStatus ?? this.driverStatus,
        verified: verified ?? this.verified,
        banCode: banCode ?? this.banCode,
        favorites: favorites ?? this.favorites,
        id: id ?? this.id,
        isDriver: isDriver ?? this.isDriver,
        email: email ?? this.email,
        first: first ?? this.first,
        last: last ?? this.last,
        address: address ?? this.address,
        health: health ?? this.health,
        ableToOrder: ableToOrder ?? this.ableToOrder);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
