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
import 'package:cazuapp_admin/components/item_extended.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/views/address/address_list.dart';
import 'package:cazuapp_admin/views/bans/set_ban.dart';
import 'package:cazuapp_admin/views/favorites/favorites_list.dart';
import 'package:cazuapp_admin/views/users/flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/etc.dart';

import '../../../components/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class UserDataPage extends StatelessWidget {
  final int id;

  const UserDataPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => UserManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(UserInfoRequest(id))),
      ],
      child: const AddressDataForm(),
    );
  }
}

class AddressDataForm extends StatelessWidget {
  const AddressDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserManagerBloc, UserManagerState>(builder: (context, state) {
      switch (state.current) {
        case UserStatus.loading:
          return const Loader();

        case UserStatus.success:
          return const FetchSuccess();

        case UserStatus.initial:
          return const Loader();

        case UserStatus.failure:
          return const Loader();
      }
    });
  }
}

class FetchSuccess extends StatefulWidget {
  const FetchSuccess({super.key});

  @override
  State<FetchSuccess> createState() => _FetchSuccessState();
}

class _FetchSuccessState extends State<FetchSuccess> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<UserManagerBloc, UserManagerState>(builder: (context, state) {
      final bool anyflag = state.user.canAssign == true || state.user.canManage == true || state.user.rootFlags == true;

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: TopBar(title: state.user.first.toString()),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        const SizedBox(height: 10),
                        Container(
                            alignment: Alignment.topLeft,
                            child: utext(
                                fontSize: 14,
                                title: state.user.first,
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
                                  ItemExtended(
                                    input: "Name",
                                    title: state.user.first,
                                    iconsrc: Icons.person,
                                  ),
                                  ItemExtended(
                                    input: "Last name",
                                    title: state.user.last,
                                    iconsrc: Icons.person_2,
                                  ),
                                  ItemExtended(
                                    input: "Email Verified",
                                    title: state.user.verified == false ? "No" : "Yes",
                                    iconsrc: Icons.email,
                                  ),
                                  ItemExtended(
                                    input: "Email",
                                    title: state.user.email,
                                    iconsrc: Icons.email,
                                  ),
                                  ItemExtended(
                                    input: "Created",
                                    title: state.user.created,
                                    iconsrc: Icons.date_range,
                                  ),
                                  ItemExtended(
                                      input: "Flags",
                                      title: Etc.betterBool(anyflag),
                                      iconsrc: FontAwesomeIcons.heartCircleBolt,
                                      onTap: () => {
                                            navigate(context, UserFlagsPage(id: state.user.id)),
                                          }),
                                  ItemExtended(
                                      input: "Favorites",
                                      title: state.user.favorites.toString(),
                                      iconsrc: FontAwesomeIcons.heartCircleBolt,
                                      onTap: () => {navigate(context, FavoritesPage(id: state.user.id))}),
                                  ItemExtended(
                                      input: "Addresses",
                                      title: state.user.address.toString(),
                                      iconsrc: FontAwesomeIcons.locationCrosshairs,
                                      onTap: () => {
                                            navigate(context, AddressListPage(id: state.user.id)),
                                          }),
                                  ItemExtended(
                                      input: "Ban",
                                      title: Etc.fromBan(state.user.banCode),
                                      iconsrc: FontAwesomeIcons.ban,
                                      onTap: () async {
                                        UserManagerBloc userManagerBloc = BlocProvider.of<UserManagerBloc>(context);

                                        userManagerBloc.add(const Load());

                                        await Navigator.of(context, rootNavigator: true)
                                            .push(
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) => SetBanPage(id: state.user.id),
                                          ),
                                        )
                                            .then((result) {
                                          userManagerBloc.add(UserInfoRequest(state.user.id));
                                        });
                                      }),
                                  ListTile(
                                    visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                                    leading: const Icon(FontAwesomeIcons.bowlFood, color: AppTheme.iconcolors),
                                    trailing: Switch(
                                      activeColor: AppTheme.lockeye,
                                      inactiveThumbColor: AppTheme.subprimarycolordeco,
                                      value: state.user.ableToOrder,
                                      onChanged: (value) {
                                        setState(() {
                                          BlocProvider.of<UserManagerBloc>(context)
                                              .add(UserManageHold(type: "orders", status: !state.user.ableToOrder));
                                        });
                                      },
                                    ),
                                    title: utext(
                                      title: "Order available",
                                      fontSize: 15,
                                      color: AppTheme.darkgray,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                                    leading: const Icon(FontAwesomeIcons.heart, color: AppTheme.iconcolors),
                                    trailing: Switch(
                                      activeColor: AppTheme.lockeye,
                                      inactiveThumbColor: AppTheme.subprimarycolordeco,
                                      value: state.user.health,
                                      onChanged: (value) {
                                        setState(() {
                                          BlocProvider.of<UserManagerBloc>(context)
                                              .add(UserManageHold(type: "health", status: !state.user.health));
                                        });
                                      },
                                    ),
                                    title: utext(
                                      title: "Unrestricted",
                                      fontSize: 15,
                                      color: AppTheme.darkgray,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                                    leading: const Icon(FontAwesomeIcons.carSide, color: AppTheme.iconcolors),
                                    trailing: Switch(
                                      activeColor: AppTheme.lockeye,
                                      inactiveThumbColor: AppTheme.subprimarycolordeco,
                                      value: state.available,
                                      onChanged: (value) {
                                        setState(() {
                                          BlocProvider.of<UserManagerBloc>(context)
                                              .add(UserSetDriverStatus(status: value));
                                        });
                                      },
                                    ),
                                    title: utext(
                                      title: "Is Driver?",
                                      fontSize: 15,
                                      color: AppTheme.darkgray,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ]))))));
    });
  }
}
