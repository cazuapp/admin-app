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

part 'ban.g.dart';

@JsonSerializable()
class BanListItem {
  final int userid;
  final String code;
  final String first;
  final String createdat;
  final String last;
  final String email;

  const BanListItem(
      {required this.userid,
      required this.code,
      required this.email,
      required this.first,
      required this.last,
      required this.createdat});
  const BanListItem.initial() : this(userid: 0, email: "", code: "noban", first: "", last: "", createdat: "");

  factory BanListItem.fromJson(Map<String, dynamic> json) => _$BanListItemFromJson(json);

  Map<String, dynamic> toJson() => _$BanToJson(this);
}
