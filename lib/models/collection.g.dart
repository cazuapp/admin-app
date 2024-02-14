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

part of 'collection.dart';

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
    id: json['id'] as int,
    piority: json['piority'] ?? 0,
    title: json['title'] ?? "",
    created: json['createdat'] ?? "",
    imagesrc: Etc.makepublic(destination: json['imagesrc']));

Map<String, dynamic> _$CollectionToJson(Collection instance) => <String, dynamic>{'id': instance.id};
