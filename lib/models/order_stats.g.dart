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

part of 'order_stats.dart';

OrderStats _$OrderStatsFromJson(Map<String, dynamic> json) => OrderStats(
    nodriver: json['nodriver'] as int,
    pending: json['pending'] as int,
    cancelled: json['cancelled'] as int,
    other: json['other'] as int,
    nopayment: json['nopayment'] as int,
    all: json['nodriver'] + json['pending'] + json['cancelled'] + json['other'] + json['nopayment'] as int);

Map<String, dynamic> _$OrderStatsToJson(OrderStats instance) => <String, dynamic>{'nodriver': instance.nodriver};
