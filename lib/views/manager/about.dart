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

import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/views/manager/manager_update.dart';
import 'package:cazuapp_admin/views/manager/store_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/etc.dart';
import '../../../components/iconextended.dart';
import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
      String? facebook = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'facebook'));
      String? instagram =
          context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'instagram'));
      String? url = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'url'));
      String? twitter = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'twitter'));
      String? address =
          context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'store_address'));

      String? name = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'storename'));
      String? current = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'orders'));
      String? maint = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'maint'));
      String? email = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'contact'));
      String? baseUrl = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'base_url'));
      String? tax = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'tax'));
      String? shipping = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'shipping'));

      String? phone = context.select((AuthenticationBloc bloc) => bloc.instance.settings.getValue(key: 'phone'));

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "Store", self: true),
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
                                    fontSize: 14, title: name!, color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                                            input: "Store",
                                            title: name,
                                            fawesome: FontAwesomeIcons.store,
                                            onTap: () => {
                                              navigate(context,
                                                  StoreUpdatePage(title: "Store name", value: name, type: "storename"))
                                            },
                                          ),
                                          IconExtended(
                                              input: "Store status",
                                              title:
                                                  Etc.fromstring(current!) == 1 ? "Accepting orders" : "Store closed",
                                              status: Etc.fromstring(current),
                                              onTap: () => {
                                                    Navigator.pop(context),
                                                    navigate(context, const StoreSettingsPage()),
                                                  }),
                                          ItemExtended(
                                              input: "Maintaince status",
                                              title: Etc.fromstring(maint!) == 1 ? "Under Maintaince" : "Store open",
                                              fawesome: FontAwesomeIcons.helicopterSymbol),
                                          ItemExtended(
                                            input: "Address",
                                            title: context.select((AuthenticationBloc bloc) =>
                                                bloc.instance.settings.getValue(key: 'store_address')),
                                            fawesome: FontAwesomeIcons.locationArrow,
                                            onTap: () => {
                                              navigate(
                                                  context,
                                                  StoreUpdatePage(
                                                      title: "Address", value: address!, type: "store_address"))
                                            },
                                          ),
                                          ItemExtended(
                                            input: "Tax",
                                            title: "\$$tax",
                                            fawesome: FontAwesomeIcons.moneyBillTransfer,
                                            onTap: () => {
                                              navigate(context, StoreUpdatePage(title: "tax", value: tax!, type: "tax"))
                                            },
                                          ),
                                          ItemExtended(
                                            input: "Shipping fee",
                                            title: "\$$shipping",
                                            fawesome: FontAwesomeIcons.moneyBillTransfer,
                                            onTap: () => {
                                              navigate(
                                                  context,
                                                  StoreUpdatePage(
                                                      title: "shipping", value: shipping!, type: "shipping"))
                                            },
                                          ),
                                          ItemExtended(
                                            input: "Email",
                                            title: email,
                                            fawesome: FontAwesomeIcons.inbox,
                                            onTap: () => {
                                              navigate(context,
                                                  StoreUpdatePage(title: "email", value: email!, type: "contact"))
                                            },
                                          ),
                                          ItemExtended(
                                            input: "Phone",
                                            iconsrc: Icons.phone_enabled,
                                            title: context.select((AuthenticationBloc bloc) =>
                                                bloc.instance.settings.getValue(key: 'phone')),
                                            onTap: () => {
                                              navigate(context,
                                                  StoreUpdatePage(title: "phone", value: phone!, type: "phone"))
                                            },
                                          ),
                                          url!.isNotEmpty
                                              ? ItemExtended(
                                                  input: "Website",
                                                  onTap: () => {
                                                        navigate(context,
                                                            StoreUpdatePage(title: "website", value: url, type: "url"))
                                                      },
                                                  title: context.select((AuthenticationBloc bloc) =>
                                                      bloc.instance.settings.getValue(key: 'url')),
                                                  fawesome: FontAwesomeIcons.chrome)
                                              : const SizedBox.shrink(),
                                          instagram!.isNotEmpty
                                              ? ItemExtended(
                                                  input: "Instagram",
                                                  onTap: () => {
                                                        navigate(
                                                            context,
                                                            StoreUpdatePage(
                                                                title: "instagram",
                                                                value: instagram,
                                                                type: "instagram"))
                                                      },
                                                  title: instagram,
                                                  fawesome: FontAwesomeIcons.instagram)
                                              : const SizedBox.shrink(),
                                          baseUrl!.isNotEmpty
                                              ? ItemExtended(
                                                  input: "Base Url",
                                                  onTap: () => {
                                                        navigate(
                                                            context,
                                                            StoreUpdatePage(
                                                                title: "Base URL", value: baseUrl, type: "base_url"))
                                                      },
                                                  title: baseUrl,
                                                  fawesome: FontAwesomeIcons.firefoxBrowser)
                                              : const SizedBox.shrink(),
                                          twitter!.isNotEmpty
                                              ? ItemExtended(
                                                  input: "Twitter",
                                                  onTap: () => {
                                                        navigate(
                                                            context,
                                                            StoreUpdatePage(
                                                                title: "twitter", value: twitter, type: "twitter"))
                                                      },
                                                  title: twitter,
                                                  fawesome: FontAwesomeIcons.twitter)
                                              : const SizedBox.shrink(),
                                          facebook!.isNotEmpty
                                              ? ItemExtended(
                                                  input: "Facebook",
                                                  onTap: () => {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => StoreUpdatePage(
                                                                    title: "facebook",
                                                                    value: facebook,
                                                                    type: "facebook")))
                                                      },
                                                  title: facebook,
                                                  fawesome: FontAwesomeIcons.facebook)
                                              : const SizedBox.shrink(),
                                        ]))),
                          ],
                        ),
                      )))));
    });
  }
}
