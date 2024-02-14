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

import 'package:cazuapp_admin/components/etc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'variant_list.g.dart';

@JsonSerializable()
class VariantListItem {
  final int productID;
  final int variantID;
  final double price;
  final String created;
  final String title;
  final String image;

  const VariantListItem(
      {required this.productID,
      required this.variantID,
      required this.price,
      required this.title,
      required this.image,
      required this.created});

  const VariantListItem.initial() : this(productID: 0, variantID: 0, price: 0, image: "", title: "", created: "");

  factory VariantListItem.fromJson(Map<String, dynamic> json) => _$VariantItemListFromJson(json);

  Map<String, dynamic> toJson() => _$VariantItemListToJson(this);
}
