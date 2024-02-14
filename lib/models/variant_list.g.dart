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

part of 'variant_list.dart';

VariantListItem _$VariantItemListFromJson(Map<String, dynamic> json) => VariantListItem(
    productID: json['product_id'] as int,
    price: json['price'].toDouble(),
    image: Etc.makepublic(destination: json['first_image']),
    title: json['title'],
    variantID: json['variant_id'] as int,
    created: json['createdat'] as String);

Map<String, dynamic> _$VariantItemListToJson(VariantListItem instance) =>
    <String, dynamic>{'productid': instance.productID};
