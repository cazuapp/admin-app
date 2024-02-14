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

import 'package:cazuapp_admin/bloc/user/user_manager/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/etc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class MyFlagsPage extends StatelessWidget {
  const MyFlagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(const WhoAmi()),
      child: const MyFlagsForm(),
    );
  }
}

class MyFlagsForm extends StatelessWidget {
  const MyFlagsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<UserManagerBloc, UserManagerState>(builder: (context, state) {
      String? root = Etc.betterBool(context.select((AuthenticationBloc bloc) => bloc.instance.getflags!.rootFlags));
      String? canAssign =
          Etc.betterBool(context.select((AuthenticationBloc bloc) => bloc.instance.getflags!.canAssign));
      String? canManage =
          Etc.betterBool(context.select((AuthenticationBloc bloc) => bloc.instance.getflags!.canManage));

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "My Flags"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: "My Flags",
                                    color: AppTheme.title,
                                    fontWeight: FontWeight.w500)),
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
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ItemExtended(input: "root", title: root, fawesome: FontAwesomeIcons.tree),
                                          ItemExtended(
                                              input: "Can Assign",
                                              title: canAssign,
                                              fawesome: FontAwesomeIcons.userPlus),
                                          ItemExtended(
                                              input: "Can Manage",
                                              title: canManage,
                                              fawesome: FontAwesomeIcons.listCheck)
                                        ]))),
                          ],
                        ),
                      )))));
    });
  }
}
