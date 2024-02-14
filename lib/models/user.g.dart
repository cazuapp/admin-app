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

part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    first: json['first'],
    last: json['last'],
    email: json['email'],
    verified: json['verified'] ?? 0,
    created: json['created'] ?? "0");

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first': instance.first,
      'last': instance.last,
      'createdat': instance.created,
      'verified': instance.verified
    };
