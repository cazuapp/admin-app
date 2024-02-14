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

import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/payment.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/src/cazuapp.dart';

class PaymentManager {
  AppInstance instance;

  Map<int, Payment> payments;

  PaymentManager({required this.instance}) : payments = <int, Payment>{};

  Future<void> loadPayments() async {
    log("Loading payments..");

    QueryResult? result = await instance.query.run(destination: AppRoutes.paymentsGetAll);

    if (!result!.ok()) {
      return;
    }

    var data = result.data["data"]["rows"];
    final counter = result.data["data"]["count"];

    for (var key in data) {
      Payment payment = Payment.fromJson(key);
      payments[key["id"]] = payment;
    }

    log("Payments loaded: $counter");
  }

  Future<bool?> keyexists({required int key}) async {
    if (payments.containsKey(key) == true) {
      return true;
    }

    return false;
  }

  Payment? getValue({required int key}) {
    if (payments.containsKey(key) == true) {
      return payments[key];
    }

    return Payment.initial();
  }
}
