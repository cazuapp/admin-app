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

import 'package:cazuapp_admin/bloc/server/info/bloc.dart';
import 'package:cazuapp_admin/bloc/settings/bloc.dart';
import 'package:cazuapp_admin/components/item_account.dart';
import 'package:cazuapp_admin/components/navigator.dart';

import 'package:cazuapp_admin/components/ok.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:cazuapp_admin/views/collections/collection_add.dart';
import 'package:cazuapp_admin/views/lister/orders/stats.dart';
import 'package:cazuapp_admin/views/manager/about.dart';
import 'package:cazuapp_admin/views/manager/my_flags.dart';
import 'package:cazuapp_admin/views/manager/store_settings.dart';
import 'package:cazuapp_admin/views/manager/whoami.dart';
import 'package:cazuapp_admin/views/products/product_add.dart';
import 'package:cazuapp_admin/views/users/driver_stats.dart';
import 'package:cazuapp_admin/views/variants/variant_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class ManagerPage extends StatelessWidget {
  const ManagerPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ManagerPage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)),
        BlocProvider(create: (_) => ServerInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)),
      ],
      child: const AccountForm(),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<ServerInfoBloc, ServerInfoState>(builder: (context, state) {
      if (state.status == ServerInfoStatus.loading) {
        return const Loader();
      }
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: TopBar(title: context.select((AuthenticationBloc bloc) => bloc.instance.getuser.first)),
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
                              utext(fontSize: 14, title: "Store", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                                    title: "Settings",
                                    fawesome: FontAwesomeIcons.gear,
                                    onTap: () => {navigate(context, const StoreSettingsPage())}),
                                ItemAccount(
                                    title: "Add Collection",
                                    fawesome: FontAwesomeIcons.folderOpen,
                                    onTap: () => {navigate(context, const CollectionAddPage())}),
                                ItemAccount(
                                    title: "Add Variant",
                                    fawesome: FontAwesomeIcons.burger,
                                    onTap: () => {navigate(context, const VariantAddPage())}),
                                ItemAccount(
                                    title: "Add Product",
                                    fawesome: FontAwesomeIcons.carrot,
                                    onTap: () => {navigate(context, const ProductAddPage())}),
                                ItemAccount(
                                    title: "Store profile",
                                    fawesome: FontAwesomeIcons.shop,
                                    onTap: () => {navigate(context, const StorePage())}),
                                ItemAccount(
                                    title: "Reset Cache",
                                    fawesome: FontAwesomeIcons.database,
                                    onTap: () => {
                                          context.read<ServerInfoBloc>()..add(const ServerResetCache()),
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(buildOk("Server reset"))
                                        }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.topLeft,
                          child:
                              utext(fontSize: 14, title: "Stats", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                                  const SizedBox(height: 6),
                                  ItemAccount(
                                      title: "Orders",
                                      fawesome: FontAwesomeIcons.truckFast,
                                      onTap: () => {
                                            Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                                                builder: (BuildContext context) => const OrderStatsPage()))
                                          }),
                                  ItemAccount(
                                      title: "Drivers' status",
                                      fawesome: FontAwesomeIcons.truckRampBox,
                                      onTap: () => {
                                            Navigator.of(context).push(CupertinoPageRoute(
                                                builder: (BuildContext context) => const DriverStatsPage()))
                                          }),
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.topLeft,
                          child: utext(
                              fontSize: 14, title: "Account", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                                  const SizedBox(height: 6),
                                  ItemAccount(
                                      title: "My flags",
                                      fawesome: FontAwesomeIcons.shieldHalved,
                                      onTap: () => {navigate(context, const MyFlagsPage())}),
                                  ItemAccount(
                                      title: "Who am I?",
                                      fawesome: FontAwesomeIcons.person,
                                      onTap: () => {
                                            Navigator.of(context).push(CupertinoPageRoute(
                                                builder: (BuildContext context) => const WhoAmiPage()))
                                          }),
                                  ItemAccount(
                                      title: "Logout",
                                      fawesome: FontAwesomeIcons.rightFromBracket,
                                      onTap: () =>
                                          {context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested())}),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }
}
