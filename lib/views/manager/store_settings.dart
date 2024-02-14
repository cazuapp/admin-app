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
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/etc.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class StoreSettingsPage extends StatelessWidget {
  const StoreSettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const StoreSettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance),
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

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: const TopBar(title: "Store settings"),
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
                          child: utext(
                              fontSize: 14, title: "Settings", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                                InkWell(
                                    child: Container(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                        child: Stack(children: <Widget>[
                                          GestureDetector(
                                            child: ListTile(
                                              visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                                              leading: const Icon(FontAwesomeIcons.store, color: AppTheme.iconcolors),
                                              trailing: Switch(
                                                activeColor: AppTheme.lockeye,
                                                inactiveThumbColor: AppTheme.subprimarycolordeco,
                                                value: Etc.asBoolean(context.select((AuthenticationBloc bloc) =>
                                                    bloc.instance.settings.getValue(key: 'orders'))),
                                                onChanged: (value) {
                                                  setState(() {
                                                    BlocProvider.of<SettingsBloc>(context).add(
                                                        SettingChanged(key: 'orders', value: Etc.toBoolean(value)));
                                                  });
                                                },
                                              ),
                                              title: utext(
                                                title: "Accept orders",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ]))),
                                InkWell(
                                    child: Container(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                        child: Stack(children: <Widget>[
                                          GestureDetector(
                                            child: ListTile(
                                              visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                                              leading: const Icon(FontAwesomeIcons.folder, color: AppTheme.iconcolors),
                                              trailing: Switch(
                                                activeColor: AppTheme.lockeye,
                                                inactiveThumbColor: AppTheme.subprimarycolordeco,
                                                value: Etc.asBoolean(context.select((AuthenticationBloc bloc) =>
                                                    bloc.instance.settings.getValue(key: 'maint'))),
                                                onChanged: (value) {
                                                  setState(() {
                                                    BlocProvider.of<SettingsBloc>(context)
                                                        .add(SettingChanged(key: 'maint', value: Etc.toBoolean(value)));
                                                  });
                                                },
                                              ),
                                              title: utext(
                                                title: "Maintaince mode",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ]))),
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
