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

import 'package:cazuapp_admin/components/tabs.dart';
import 'package:cazuapp_admin/views/home/home.dart';
import 'package:cazuapp_admin/views/lister/lister.dart';
import 'package:cazuapp_admin/views/manager/manager.dart';
import 'package:cazuapp_admin/views/users/main/userlist.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MenuPage());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuForm(),
    );
  }
}

class MenuForm extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();

  MenuForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: const HomePage(),
          icon: const Icon(FontAwesomeIcons.house),
          title: 'Home',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const UserListPage(),
          icon: const Icon(FontAwesomeIcons.personWalkingArrowLoopLeft),
          title: 'Users',
          //  navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: const ListerPage(),
          icon: const Icon(FontAwesomeIcons.folderTree),
          title: 'Listers',
          //  navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: const ManagerPage(),
          icon: const Icon(FontAwesomeIcons.gauge),
          title: 'Admin',
          //  navigatorkey: _tab4navigatorKey,
        ),
      ],
    );
  }
}
