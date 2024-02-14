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

import 'dart:developer';

import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/item.dart';
import 'package:cazuapp_admin/models/order_info.dart';
import 'package:cazuapp_admin/models/order_list.dart';
import 'package:cazuapp_admin/models/order_stats.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

class OrdersManager {
  AppInstance instance;
  OrdersManager({required this.instance});

  Future<int?> cancel({required int id, required int userid}) async {
    log("Cancelling order $id from userid: $userid");

    QueryResult? result =
        await instance.query.run(override: userid, destination: AppRoutes.orderCancel, body: {"id": id});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  Future<DualResult?> getItems({int offset = 0, int limit = 10, int id = 0}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.getItems, body: {"offset": offset, "limit": limit, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var counter = result.data["data"]["count"];
    var data = result.data["data"]["rows"];

    List<Item> items = <Item>[];

    for (var key in data) {
      Item order = Item.fromJson(key);
      items.add(order);
    }

    return DualResult(status: Protocol.ok, model: items, model2: counter);
  }

  Future<DualResult?> home({int offset = 0, int limit = 10, Param param = Param.all}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.getHome,
        body: {"status": "pending", "offset": offset, "limit": limit, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    var counter = result.data["counter"];
    return DualResult(status: Protocol.ok, model: orders, model2: counter);
  }

  Future<DualResult?> search({String text = '', int offset = 0, int limit = 10, Param param = Param.pending}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.orderSearchAllBy,
        body: {"param": "pending", "id": text, "offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    var counter = result.data["counter"];
    return DualResult(status: Protocol.ok, model: orders, model2: counter);
  }

  Future<DualResult?> info({required int userid, required int id}) async {
    QueryResult? result =
        await instance.query.run(override: userid, destination: AppRoutes.orderInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];
    OrderInfo order = OrderInfo.fromJson(data);

    return DualResult(model: order, status: Protocol.ok);
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
