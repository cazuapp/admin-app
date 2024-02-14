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

part of 'flags.dart';

Flags _$FlagsFromJson(Map<String, dynamic> json) => Flags(
    rootFlags: Etc.intToBoolean(json['root_flags']),
    canAssign: Etc.intToBoolean(json['can_assign']),
    canManage: Etc.intToBoolean(json['can_manage']));

Map<String, dynamic> _$FlagsToJson(Flags instance) => <String, dynamic>{'root_flags': instance.rootFlags};
