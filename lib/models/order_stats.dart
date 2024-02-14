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

part 'order_stats.g.dart';

@JsonSerializable()
class OrderStats {
  final int nodriver;
  final int pending;
  final int cancelled;
  final int other;
  final int nopayment;
  final int all;

  OrderStats(
      {required this.nodriver,
      required this.all,
      required this.pending,
      required this.cancelled,
      required this.other,
      required this.nopayment});

  OrderStats.initial() : this(nodriver: 0, pending: 0, all: 0, cancelled: 0, other: 0, nopayment: 0);

  factory OrderStats.fromJson(Map<String, dynamic> json) => _$OrderStatsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatsToJson(this);
}
