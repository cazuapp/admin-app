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

/*
 * Main class. AppInstance contains all inits to other classes.
 * This class is in charge of handling other classes and to
 * manipulate data as requested.
 * 
 * AppInstance is singleton and is initialized only once.
 */

import 'dart:developer';
import 'dart:io';

import 'package:cazuapp_admin/bloc/user/auth/repository.dart';
import 'package:cazuapp_admin/components/request.dart';
import 'package:cazuapp_admin/core/httpr.dart';
import 'package:cazuapp_admin/core/routes.dart';
import 'package:cazuapp_admin/models/first_ping.dart';
import 'package:cazuapp_admin/models/flags.dart';
import 'package:cazuapp_admin/models/queryresult.dart';
import 'package:cazuapp_admin/models/server.dart';
import 'package:cazuapp_admin/models/user.dart';
import 'package:cazuapp_admin/src/address.dart';
import 'package:cazuapp_admin/src/api.dart';
import 'package:cazuapp_admin/src/auth.dart';
import 'package:cazuapp_admin/src/bans.dart';
import 'package:cazuapp_admin/src/collections.dart';
import 'package:cazuapp_admin/src/drivers.dart';
import 'package:cazuapp_admin/src/orders.dart';
import 'package:cazuapp_admin/src/payments.dart';
import 'package:cazuapp_admin/src/preferences.dart';
import 'package:cazuapp_admin/src/products.dart';
import 'package:cazuapp_admin/src/server.dart';
import 'package:cazuapp_admin/src/stats.dart';
import 'package:cazuapp_admin/src/users.dart';
import 'package:cazuapp_admin/src/variants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'settings.dart';

class AppInstance {
  late String installed;
  late String os;
  late String version;

  /* Time at which AppInstance was initialized */

  late DateTime startup;

  /* Auth Manager */

  late AuthManager auth;

  /* Servers' initial ping */

  late FirstPing firstping;

  AuthenticationRepository? authenticationRepository;

  late SettingsManager settings;
  late PreferencesManager preferences;
  late OrdersManager orders;
  late PaymentManager payments;
  late BansManager bans;

  /* Address manager */

  late AddressManager address;

  /* Collection manager */

  late CollectionManager collections;

  /* Variant collection */

  late VariantManager variants;
  late UserManager users;
  late DriverManager drivers;
  late QueryManager query;
  late ProductManager products;
  late ServerManager server;

  late Flags _flags;
  late Server _server;

  late User _user;
  User get getuser => _user;
  Stats? stats;

  Server? get getserver => _server;
  Flags? get getflags => _flags;

  set setuser(User usr) => _user = usr;
  set setserver(Server srv) => _server = srv;

  set setflags(Flags flg) => _flags = flg;

  static final AppInstance instance = AppInstance.build();

  Future<void> setup() async {
    log("Running setup..");
    await instance.settings.loadSettings();
    await instance.payments.loadPayments();

    await instance.preferences.loadSettings();
    //    await instance.auth.stats();
  }

  AppInstance.build() {
    _flags = Flags.initial();
    _user = User.initial();
    firstping = FirstPing.initial();
    server = ServerManager(instance: this);
    variants = VariantManager(instance: this);
    bans = BansManager(instance: this);

    collections = CollectionManager(instance: this);
    products = ProductManager(instance: this);
    address = AddressManager(instance: this);
    orders = OrdersManager(instance: this);
    drivers = DriverManager(instance: this);
    payments = PaymentManager(instance: this);

    authenticationRepository = AuthenticationRepository(instance: this);
    users = UserManager(instance: this);
    auth = AuthManager(instance: this);
    startup = DateTime.now();
    os = Platform.operatingSystem;
    version = Platform.operatingSystemVersion;
    stats = Stats();
    query = QueryManager(instance: this);
    settings = SettingsManager(instance: this);
    preferences = PreferencesManager(instance: this);

    if (kIsWeb) {
      SystemNavigator.pop();
      exit(0);
    }
  }

  Future init() async {
    log('Initializing instance');
    await dotenv.load(fileName: ".env");

    await auth.load();

    if (dotenv.env['env'] == "development" && int.parse(dotenv.env['autolog']!) == 1) {
      await instance.auth.login(
          email: dotenv.env['autolog_email'].toString(),
          password: dotenv.env['autolog_password'].toString(),
          doSetup: true,
          remember: true);
    }
  }

  factory AppInstance() {
    return instance;
  }

  Future<bool?> pingServer() async {
    log('First ping');

    /* doLogin basically means that this query does not need to use login token */

    QueryResult? result = await query.run(doLogin: false, type: RequestType.get, destination: AppRoutes.initPing);

    if (!result!.ok()) {
      if (result.getStatus() == Httpr.maint) {
        await instance.auth.maint();
      }

      return false;
    }

    var data = result.data["data"];

    firstping = FirstPing.fromJson(data);

    if (firstping.maint == true) {
      log("Server is under maintaince");
      await instance.auth.maint();
      return false;
    }

    return true;
  }
}
