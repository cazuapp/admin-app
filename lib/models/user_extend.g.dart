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

part of 'user_extend.dart';

UserExtend _$UserFromJson(Map<String, dynamic> json) => UserExtend(
    id: json['id'] as int,
    created: json['createdat'] ?? "",
    available: json['available'] ?? false,
    rootFlags: Etc.intToBoolean(json['root_flags']),
    canManage: Etc.intToBoolean(json['can_manage']),
    canAssign: Etc.intToBoolean(json['can_assign']),
    favorites: json['favorites'] ?? 0,
    address: json['address'] ?? 0,
    isDriver: json['is_driver'] ?? false,
    first: json['first'],
    driverStatus: json['driver_status'] ?? false,
    last: json['last'],
    email: json['email'],
    verified: json['verified'] ?? false,
    banCode: json['ban_code'] ?? "noban",
    ableToOrder: json['able_to_order'] ?? true,
    health: json['health'] ?? true);

Map<String, dynamic> _$UserToJson(UserExtend instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first': instance.first,
      'last': instance.last,
      'verified': instance.verified
    };
