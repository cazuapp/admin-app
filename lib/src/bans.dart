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
import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/ban.dart';
import 'package:cazuapp_admin/models/order_list.dart';
import 'package:cazuapp_admin/models/order_stats.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/models/user_extend.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

class BansManager {
  AppInstance instance;
  BansManager({required this.instance});

  Future<DualResult?> list({int offset = 0, int limit = 10, Param param = Param.all}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.listAllBans, body: {"offset": offset, "limit": limit, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<BanListItem> bans = <BanListItem>[];

    for (var key in data) {
      BanListItem ban = BanListItem.fromJson(key);
      bans.add(ban);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: bans, model2: counter);
  }

  Future<DualResult?> search({String text = '', int offset = 0, int limit = 10, Param param = Param.pending}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.searchBans,
        body: {"value": text, "offset": offset, "limit": limit, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<BanListItem> bans = <BanListItem>[];

    for (var key in data) {
      BanListItem ban = BanListItem.fromJson(key);
      bans.add(ban);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: bans, model2: counter);
  }

  Future<DualResult?> delete({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.banDelete, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];

    return DualResult(model: data, status: Protocol.ok);
  }

  Future<DualResult?> setban({required int id, required BanCodeStatus code}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.banSet, body: {"id": id, "code": code.toShortString()});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];

    return DualResult(model: data, status: Protocol.ok);
  }

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.userSuperInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];
    UserExtend extend = UserExtend.fromJson(data);

    return DualResult(model: extend, status: Protocol.ok);
  }

  Future<DualResult?> getuser({int offset = 0, int limit = 10, List? conditions, required int id}) async {
    QueryResult? result =
        await instance.query.run(override: id, destination: AppRoutes.orderGet, body: {"conditions": conditions});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    return DualResult(status: Protocol.ok, model: orders);
  }

  Future<DualResult?> get({int offset = 0, int limit = 10, List? conditions}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.orderGetAllBy, body: {"value": conditions, "offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    return DualResult(status: Protocol.ok, model: orders);
  }

  Future<DualResult?> stats() async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.orderStats, body: {});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];

    return DualResult(model: OrderStats.fromJson(data), status: Protocol.ok);
  }
}
