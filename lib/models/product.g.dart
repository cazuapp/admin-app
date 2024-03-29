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

part of 'product.dart';

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    type: json['type'] ?? "",
    collectionName: json['collection_title'] ?? "",
    name: json['name'] ?? "",
    description: json['description'] ?? '',
    price: json['price'].toDouble(),
    piority: json['piority'] ?? 0,
    collection: json['collection'],
    image: json['image'] != null
        ? Etc.makepublic(destination: json['image'])
        : Etc.makepublic(destination: "assets/images/etc/null.png"));

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'collection': instance.collection,
      'image': instance.image
    };
