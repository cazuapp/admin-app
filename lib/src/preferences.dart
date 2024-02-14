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

import 'package:cazuapp_admin/core/protocol.dart';
import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

class PreferencesManager {
  AppInstance instance;

  Map<String, String> preferences;

  PreferencesManager({required this.instance}) : preferences = <String, String>{};

  Future<int?> set({required String key, required String value}) async {
    preferences[key] = value;

    QueryResult? result =
        await instance.query.run(destination: AppRoutes.preferencesSet, body: {"key": key, "value": value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  Future<void> loadSettings() async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.preferencesGetAll);

    if (!result!.ok()) {
      return;
    }

    var data = result.data["data"];

    for (var key in data) {
      preferences[key["key"]] = key["value"];
    }
  }

  Future<bool?> keyexists({required String key}) async {
    if (preferences.containsKey(key) == true) {
      return true;
    }

    return false;
  }

  String? getValue({required String key}) {
    if (preferences.containsKey(key) == true) {
      return preferences[key];
    }

    return "";
  }
}
