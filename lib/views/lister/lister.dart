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

import 'package:cazuapp_admin/bloc/settings/bloc.dart';
import 'package:cazuapp_admin/components/item_account.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:cazuapp_admin/views/bans/bans/home.dart';
import 'package:cazuapp_admin/views/lister/admin/adminlist.dart';
import 'package:cazuapp_admin/views/lister/collections/collections_list.dart';
import 'package:cazuapp_admin/views/lister/drivers/driverlist.dart';
import 'package:cazuapp_admin/views/lister/products/products_list.dart';
import 'package:cazuapp_admin/views/lister/variants/variants_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class ListerPage extends StatelessWidget {
  const ListerPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ListerPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance),
      child: const ListForm(),
    );
  }
}

class ListForm extends StatefulWidget {
  const ListForm({super.key});

  @override
  State<ListForm> createState() => ListFormState();
}

class ListFormState extends State<ListForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: const TopBar(title: "Lists"),
        body: SafeArea(
          child: SizedBox(
              height: size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.03),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Container(
                          alignment: Alignment.topLeft,
                          child:
                              utext(fontSize: 14, title: "Lists", color: AppTheme.title, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Expanded(
                        flex: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(width: 1, color: Colors.white)),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ItemAccount(
                                    title: "Drivers",
                                    fawesome: FontAwesomeIcons.truckPickup,
                                    onTap: () => {navigate(context, const DriverListPage())}),
                                ItemAccount(
                                    title: "Admins",
                                    fawesome: FontAwesomeIcons.solidFlag,
                                    onTap: () => {navigate(context, const AdminListPage())}),
                                ItemAccount(
                                    title: "Products",
                                    fawesome: FontAwesomeIcons.carrot,
                                    onTap: () => {navigate(context, const ProductListPage())}),
                                ItemAccount(
                                    title: "Variants",
                                    fawesome: FontAwesomeIcons.burger,
                                    onTap: () => {navigate(context, const VariantListPage())}),
                                ItemAccount(
                                    title: "Collections",
                                    fawesome: FontAwesomeIcons.folderOpen,
                                    onTap: () => {navigate(context, const CollectionListPage())}),
                                ItemAccount(
                                    title: "Bans",
                                    fawesome: FontAwesomeIcons.ban,
                                    onTap: () => {navigate(context, const BansHomePage())}),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }
}
