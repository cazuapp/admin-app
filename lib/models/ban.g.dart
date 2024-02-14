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

part of 'ban.dart';

Map<String, dynamic> _$BanToJson(BanListItem instance) => <String, dynamic>{'userid': instance.userid};

BanListItem _$BanListItemFromJson(Map<String, dynamic> json) => BanListItem(
      userid: json['userid'] as int,
      code: json['code'] ?? "noban",
      first: json['first'] ?? "",
      last: json['last'] ?? "",
      email: json['email'] ?? "",
      createdat: json['createdat'] ?? "",
    );
