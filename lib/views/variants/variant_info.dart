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

import 'package:cazuapp_admin/bloc/variants/info/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/models/variant.dart';
import 'package:cazuapp_admin/views/products/product_info.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class VariantInfoPage extends StatelessWidget {
  const VariantInfoPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /* Loads variant data upon opening of page */

      create: (_) =>
          VariantInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(Info(id: id)),
      child: const VariantInfoForm(),
    );
  }
}

class VariantInfoForm extends StatelessWidget {
  const VariantInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<VariantInfoBloc, VariantInfoState>(builder: (context, state) {
      Variant variant = state.variant;

      switch (state.status) {
        case VariantInfoStatus.deleted:
          return const Loader();
        case VariantInfoStatus.initial:
          return const Loader();
        case VariantInfoStatus.loading:
          return const Loader();

        case VariantInfoStatus.failure:
          return const FailurePage(title: "Variant info", subtitle: "Failed to retrieve variant information");

        case VariantInfoStatus.success:
          return Scaffold(
              backgroundColor: AppTheme.background,
              appBar: const TopBar(title: "Variant information"),
              body: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: utext(
                                        fontSize: 14,
                                        title: "Variant #${variant.id.toString()}",
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
                                                input: "ID",
                                                title: variant.id.toString(),
                                                fawesome: FontAwesomeIcons.listOl,
                                              ),
                                              ItemExtended(
                                                input: "Title",
                                                title: variant.title.toString(),
                                                fawesome: FontAwesomeIcons.objectGroup,
                                              ),
                                              ItemExtended(
                                                input: "Price",
                                                title: variant.price.toString(),
                                                fawesome: FontAwesomeIcons.dollarSign,
                                              ),
                                              ItemExtended(
                                                input: "Stock",
                                                title: variant.stock == -1 ? "Unlimited" : variant.stock.toString(),
                                                fawesome: FontAwesomeIcons.chartBar,
                                              ),
                                              ItemExtended(
                                                input: "Product id",
                                                title: variant.productID.toString(),
                                                fawesome: FontAwesomeIcons.carrot,
                                                onTap: () => {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ProductInfoPage(id: variant.productID)))
                                                },
                                              ),
                                            ]))),
                              ],
                            ),
                          )))));
      }
    });
  }
}
