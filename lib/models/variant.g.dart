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

part of 'variant.dart';

Variant _$VariantFromJson(Map<String, dynamic> json) => Variant(
      id: json['variant_id'] as int,
      productID: json['product_id'] as int,
      stock: json['stock'] as int,
      title: json['variant_title'] as String,
      images: json['images'] != null
          ? (json['images'] as List<dynamic>)
              .map(
                (dynamic item) => VariantImage.fromJson(item as Map<String, dynamic>),
              )
              .toList()
          : <VariantImage>[],
      price: json['price'].toDouble() ?? 0.0,
    );

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{'id': instance.id, 'price': instance.price};
