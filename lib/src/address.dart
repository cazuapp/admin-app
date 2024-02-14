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

import 'package:cazuapp_admin/models/address.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../components/request.dart';
import '../core/routes.dart';
import '../models/queryresult.dart';

extension ParseKeyToString on LocalKeyEvent {
  String toShortString() {
    return toString().split('.').last;
  }
}

class AddressManager {
  AppInstance instance;

  AddressManager({required this.instance});

  Future<int?> delete({required int id, required int over}) async {
    QueryResult? result = await instance.query.run(override: over, destination: AppRoutes.appDelete, body: {"id": id});

    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    return Protocol.ok;
  }

  Future<DualResult?> info({required int id, required int over}) async {
    QueryResult? result =
        await instance.query.run(override: over, destination: AppRoutes.addressInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];

    return DualResult(model: Address.fromJson(data), status: Protocol.ok);
  }

  Future<int?> update({required int user, required int id, required LocalKeyEvent key, required String value}) async {
    QueryResult? result = await instance.query
        .run(override: user, destination: AppRoutes.addressUpdate, body: {"id": id, key.toShortString(): value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  Future<DualResult?> get({required int over, int offset = 0, int limit = 10}) async {
    QueryResult? result = await instance.query
        .run(override: over, destination: AppRoutes.addressGet, body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Address> addresses = <Address>[];

    int total = result.data["data"]["count"];

    var data = result.data["data"]["rows"];

    for (var key in data) {
      Address item = Address.fromJson(key);
      addresses.add(item);
    }

    return DualResult(model: addresses, model2: total, status: Protocol.ok);
  }
}
