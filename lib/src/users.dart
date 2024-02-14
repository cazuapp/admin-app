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

import 'package:cazuapp_admin/models/product.dart';
import 'package:cazuapp_admin/models/user.dart';
import 'package:cazuapp_admin/models/user_extend.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../core/routes.dart';
import '../models/queryresult.dart';

class UserManager {
  AppInstance instance;

  UserManager({required this.instance});

  Future<void> init() async {}

  Future<DualResult?> adminSearch({
    int offset = 0,
    int limit = 10,
    String value = "",
  }) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.adminSearch, body: {"offset": offset, "limit": limit, "value": value});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<User> users = <User>[];

    var data = result.data["data"];

    for (var key in data) {
      User user = User.fromJson(key);
      users.add(user);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: users, model2: total);
  }

  Future<DualResult?> adminList({
    int offset = 0,
    int limit = 10,
  }) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.admingetAll, body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<User> users = <User>[];

    var data = result.data["data"];

    for (var key in data) {
      User user = User.fromJson(key);
      users.add(user);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: users, model2: total);
  }

  Future<DualResult?> list({int offset = 0, int limit = 10}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.userListQuery, body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<User> users = <User>[];

    var data = result.data["data"];

    for (var key in data) {
      User user = User.fromJson(key);
      users.add(user);
    }

    int total = result.data["counter"];
    return DualResult(status: Protocol.ok, model: users, model2: total);
  }

  Future<DualResult?> favorites({int over = 0, int offset = 0, int limit = 10}) async {
    QueryResult? result = await instance.query
        .run(override: over, destination: AppRoutes.favoritesGetJoin, body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Product> variants = <Product>[];

    var data = result.data["rows"];

    for (var key in data) {
      Product item = Product.fromJson(key);
      variants.add(item);
    }

    int total = result.data["counter"];

    return DualResult(model: variants, status: Protocol.ok, model2: total);
  }

  Future<DualResult?> flagsUpsert({required int id, required String value, required bool status}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.flagsUpsert, body: {value: status, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }

  Future<DualResult?> unassign({required int order}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.unassign, body: {"id": order});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }

  Future<DualResult?> take({required int user, required int order}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.assignOrder, body: {"id": order, "user": user});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }

  Future<DualResult?> driverStatus({required int id, required bool status}) async {
    QueryResult? result =
        await instance.query.run(override: id, destination: AppRoutes.setStatus, body: {"value": status});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }

  Future<DualResult?> holdUpsert({required int id, required bool status}) async {
    QueryResult? result =
        await instance.query.run(override: id, destination: AppRoutes.holdsUpsert, body: {"value": status});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }

  Future<DualResult?> holdsManage({required int id, required bool ableToOrder, required bool health}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.holdsUpsert, body: {"id": id, "able_to_order": ableToOrder, "health": health});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }

  Future<bool?> driverManage({required int id, required bool status}) async {
    String dest = "";

    if (status == false) {
      dest = AppRoutes.deleteDriver;
    } else {
      dest = AppRoutes.addDriver;
    }

    QueryResult? result = await instance.query.run(destination: dest, body: {"id": id});

    if (!result!.ok()) {
      return false;
    }

    return true;
  }

  Future<DualResult?> search({int offset = 0, int limit = 10, String value = "", bool list = false}) async {
    Map<String, dynamic> query = {"offset": offset, "limit": limit};

    if (list == false) {
      query["value"] = value;
    }

    QueryResult? result = await instance.query.run(destination: AppRoutes.userSearchQuery, body: query);

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<User> users = <User>[];

    var data = result.data["data"];

    for (var key in data) {
      User user = User.fromJson(key);
      users.add(user);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: users, model2: total);
  }

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.userSuperInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];
    UserExtend user = UserExtend.fromJson(data);

    return DualResult(model: user, status: Protocol.ok);
  }
}
