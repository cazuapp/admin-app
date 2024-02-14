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
import 'package:cazuapp_admin/components/request.dart';
import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/collection.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';
import 'package:dio/dio.dart';

class CollectionManager {
  AppInstance instance;

  CollectionManager({required this.instance});

  Future<void> init() async {}

  Future<int?> update({required int id, required String key, required dynamic value}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.collectionsUpdate, body: {"id": id, key: value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  Future<DualResult?> search({int offset = 0, int limit = 10, required String text}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.collectionsSearch, body: {"offset": offset, "limit": limit, "value": text});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Collection> collections = <Collection>[];

    var data = result.data["data"];

    for (var key in data) {
      Collection collection = Collection.fromJson(key);
      collections.add(collection);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: collections, model2: total);
  }

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.collectionsInfo, body: {"id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];

    return DualResult(model: Collection.fromJson(data), status: Protocol.ok);
  }

  Future<DualResult?> list({int offset = 0, int limit = 10, id = 0}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.collectionsGet, body: {"offset": offset, "limit": limit, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Collection> collections = <Collection>[];

    var data = result.data["data"];

    for (var key in data) {
      Collection collection = Collection.fromJson(key);
      collections.add(collection);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: collections, model2: total);
  }

  Future<DualResult?> add({required String title, required String image, required int piority}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.collectionsAdd, body: {
      "title": title,
      "piority": piority,
    });

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    int id = result.data["data"]["id"];

    String fileName = image.split('/').last;
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(image, filename: fileName), "type": "collections", "id": id});

    await instance.query.run(destination: AppRoutes.upload, type: RequestType.file, form: formData);

    return DualResult(status: Protocol.ok, model2: id);
  }

  Future<int?> delete({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.collectionsDelete, body: {"id": id});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }
}
