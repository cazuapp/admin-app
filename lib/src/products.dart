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

import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/product.dart';
import 'package:cazuapp_admin/models/product_list.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

class ProductManager {
  AppInstance instance;

  ProductManager({required this.instance});

  Future<void> init() async {}

  Future<DualResult?> search({int collection = 0, int offset = 0, int limit = 10, required String value}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.searchQuery, body: {"offset": offset, "limit": limit, "value": value, "id": collection});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<ProductListItem> products = <ProductListItem>[];

    var data = result.data["data"];

    for (var key in data) {
      ProductListItem product = ProductListItem.fromJson(key);
      products.add(product);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: products, model2: counter);
  }

  Future<DualResult?> list({int collection = 0, int offset = 0, int limit = 10}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.homeGet, body: {"offset": offset, "limit": limit, "id": collection});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<ProductListItem> products = <ProductListItem>[];

    var data = result.data["data"];

    for (var key in data) {
      ProductListItem item = ProductListItem.fromJson(key);
      products.add(item);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: products, model2: counter);
  }

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.productsInfo, body: {"id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"][0];

    return DualResult(model: Product.fromJson(data), status: Protocol.ok);
  }

  Future<int?> update({required int id, required String key, required dynamic value}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.productsUpdate, body: {"id": id, key: value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  Future<DualResult?> add({
    required int collection,
    required String name,
    required String description,
    required int piority,
  }) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.productsAdd,
        body: {"collection": collection, "name": name, "description": description, "piority": piority});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    int id = result.data["data"]["id"];

    return DualResult(status: Protocol.ok, model2: id);
  }

  Future<int?> delete({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.productsDelete, body: {"id": id});

    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    return Protocol.ok;
  }
}
