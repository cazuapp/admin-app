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

part 'collection.g.dart';

@JsonSerializable()
class Collection {
  final int id;
  final int piority;
  final String title;
  final String imagesrc;
  final String created;

  const Collection(
      {required this.id, required this.piority, required this.title, required this.imagesrc, required this.created});

  const Collection.initial() : this(id: 0, piority: 0, title: "", imagesrc: "", created: "");

  Collection copyWith({int? id, String? title, int? piority, String? imagesrc, String? created}) {
    return Collection(
        id: id ?? this.id,
        created: created ?? this.created,
        piority: piority ?? this.piority,
        imagesrc: imagesrc ?? this.imagesrc,
        title: title ?? this.title);
  }

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}
