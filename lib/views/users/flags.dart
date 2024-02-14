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
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class UserFlagsPage extends StatelessWidget {
  const UserFlagsPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => UserManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(UserInfoRequest(id))),
      ],
      child: const UserFlagsForm(),
    );
  }
}

class UserFlagsForm extends StatefulWidget {
  const UserFlagsForm({super.key});

  @override
  State<UserFlagsForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<UserFlagsForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<UserManagerBloc, UserManagerState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: TopBar(title: "Flags > ${state.user.first} ${state.user.last}"),
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
                              utext(fontSize: 14, title: "Flags", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                                                value: state.user.rootFlags,
                                                onChanged: (value) {
                                                  context.read<UserManagerBloc>().add(
                                                      SetFlag(user: state.user.id, value: "root_flags", status: value));
                                                },
                                              ),
                                              title: utext(
                                                title: "Full privileges (root)",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
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
                                              leading: const Icon(FontAwesomeIcons.store, color: AppTheme.iconcolors),
                                              trailing: Switch(
                                                activeColor: AppTheme.lockeye,
                                                inactiveThumbColor: AppTheme.subprimarycolordeco,
                                                value: state.user.canAssign,
                                                onChanged: (value) {
                                                  context.read<UserManagerBloc>().add(
                                                      SetFlag(user: state.user.id, value: "can_assign", status: value));
                                                },
                                              ),
                                              title: utext(
                                                title: "Can assign",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
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
                                              leading: const Icon(FontAwesomeIcons.store, color: AppTheme.iconcolors),
                                              trailing: Switch(
                                                activeColor: AppTheme.lockeye,
                                                inactiveThumbColor: AppTheme.subprimarycolordeco,
                                                value: state.user.canManage,
                                                onChanged: (value) {
                                                  context.read<UserManagerBloc>().add(
                                                      SetFlag(user: state.user.id, value: "can_manage", status: value));
                                                },
                                              ),
                                              title: utext(
                                                title: "Can Manage",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
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
