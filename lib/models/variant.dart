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

import 'package:cazuapp_admin/models/variant_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'variant.g.dart';

@JsonSerializable()
class Variant {
  final int id;
  final int productID;
  final String title;
  final int stock;
  final double price;
  final List<VariantImage> images;

  const Variant(
      {required this.id,
      required this.stock,
      required this.productID,
      required this.title,
      required this.price,
      this.images = const <VariantImage>[]});

  const Variant.initial() : this(id: 0, stock: 0, title: "", productID: 0, price: 0.0, images: const <VariantImage>[]);

  Variant copyWith(
      {int? stock,
      int? productID,
      int? id,
      String? title,
      String? productName,
      double? price,
      List<VariantImage>? images}) {
    return Variant(
        stock: stock ?? this.stock,
        title: title ?? this.title,
        productID: productID ?? this.productID,
        id: id ?? this.id,
        price: price ?? this.price,
        images: images ?? this.images);
  }

  factory Variant.fromJson(Map<String, dynamic> json) => _$VariantFromJson(json);

  Map<String, dynamic> toJson() => _$VariantToJson(this);
}
