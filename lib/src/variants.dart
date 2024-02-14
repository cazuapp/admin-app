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
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/components/request.dart';
import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/core/routes.dart';

import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/models/variant.dart';
import 'package:cazuapp_admin/models/variant_list.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:dio/dio.dart';

class VariantManager {
  AppInstance instance;

  VariantManager({required this.instance});

  Future<void> init() async {}

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.variantInfo, body: {"id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];

    return DualResult(model: Variant.fromJson(data), status: Protocol.ok);
  }

  Future<DualResult?> add(
      {required String title, required double price, required int product, required String image}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.variantsAdd, body: {"title": title, "price": price, "product": product});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    int id = result.data["data"]["id"];

    String fileName = image.split('/').last;
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(image, filename: fileName), "type": "variants", "id": id});

    await instance.query.run(destination: AppRoutes.upload, type: RequestType.file, form: formData);

    return DualResult(status: Protocol.ok, model2: id);
  }

  Future<DualResult?> search(
      {int product = 0, String text = '', int offset = 0, int limit = 10, Param param = Param.pending}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.variantSearchAllBy,
        body: {"id": product, "value": text, "offset": offset, "limit": limit, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<VariantListItem> variants = <VariantListItem>[];

    for (var key in data) {
      VariantListItem variant = VariantListItem.fromJson(key);
      variants.add(variant);
    }

    var counter = result.data["counter"];
    var header = result.data["header"];

    /* Return counter as dynamic data so it can be later displayed */

    return DualResult(status: Protocol.ok, model: variants, model2: counter, model3: header);
  }

  Future<DualResult?> list({int product = 0, int offset = 0, int limit = 10, Param param = Param.all}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.variantsList,
        body: {"status": "pending", "offset": offset, "limit": limit, "id": product, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<VariantListItem> variants = <VariantListItem>[];

    for (var key in data) {
      VariantListItem list = VariantListItem.fromJson(key);
      variants.add(list);
    }

    var counter = result.data["counter"];
    var header = result.data["header"];

    return DualResult(status: Protocol.ok, model: variants, model2: counter, model3: header);
  }
}
