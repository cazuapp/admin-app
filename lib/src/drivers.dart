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

import 'package:cazuapp_admin/models/driver_stats.dart';
import 'package:cazuapp_admin/models/user.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../core/routes.dart';
import '../models/queryresult.dart';

class DriverManager {
  AppInstance instance;

  DriverManager({required this.instance});

  Future<void> init() async {}

  Future<DualResult?> stats() async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.driverStats, body: {});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];

    return DualResult(model: DriverStats.fromJson(data), status: Protocol.ok);
  }

  Future<DualResult?> search({int offset = 0, int limit = 10, String? value = ""}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.driverSearchQuery, body: {"offset": offset, "limit": limit, "value": value});

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
        await instance.query.run(destination: AppRoutes.driverList, body: {"offset": offset, "limit": limit});

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

  Future<DualResult?> getfullavailable({int offset = 0, int limit = 10, bool available = false}) async {
    Map<String, dynamic> query = {"offset": offset, "limit": limit, "available": available};

    QueryResult? result = await instance.query.run(destination: AppRoutes.driversGetfullavailable, body: query);

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<User> users = <User>[];

    var data = result.data["data"];

    for (var key in data) {
      User user = User.fromJson(key);
      users.add(user);
    }

    int total = result.data["queries"];

    return DualResult(status: Protocol.ok, model: users, model2: total);
  }
}
