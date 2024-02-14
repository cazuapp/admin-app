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

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final int collection;

  final String image;
  final String name;
  final String description;
  final String collectionName;
  final double price;
  final int piority;
  final String type;

  const Product(
      {required this.description,
      required this.type,
      required this.piority,
      required this.id,
      required this.collectionName,
      required this.image,
      required this.collection,
      required this.name,
      required this.price});

  const Product.initial()
      : this(
            collectionName: "",
            type: "",
            description: "",
            piority: 0,
            id: 0,
            image: "",
            collection: 0,
            name: "",
            price: 0.0);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith(
      {int? collection,
      double? price,
      String? collectionName,
      String? image,
      int? piority,
      int? id,
      String? name,
      String? type,
      String? description}) {
    return Product(
        price: price ?? this.price,
        collectionName: collectionName ?? this.collectionName,
        image: image ?? this.image,
        piority: piority ?? this.piority,
        id: id ?? this.id,
        collection: collection ?? this.collection,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description);
  }
}
