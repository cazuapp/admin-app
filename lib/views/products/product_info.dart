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

import 'package:cazuapp_admin/bloc/products/info/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/item_dep.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/views/collections/collection_info.dart';
import 'package:cazuapp_admin/views/lister/variants/variants_list.dart';

import 'package:cazuapp_admin/views/products/confirm_delete.dart';
import 'package:cazuapp_admin/views/products/products_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class ProductInfoPage extends StatelessWidget {
  const ProductInfoPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(FetchInfo(id: id)),
      child: const ProductInfoForm(),
    );
  }
}

class ProductInfoForm extends StatelessWidget {
  const ProductInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<ProductInfoBloc, ProductInfoState>(builder: (context, state) {
      switch (state.status) {
        case ProductInfoStatus.deleted:
          return const Loader();
        case ProductInfoStatus.initial:
          return const Loader();
        case ProductInfoStatus.loading:
          return const Loader();

        case ProductInfoStatus.failure:
          return const FailurePage(title: "Product info", subtitle: "Failed to retrieve product information");

        case ProductInfoStatus.success:
          return Scaffold(
              backgroundColor: AppTheme.background,
              appBar: TopBar(title: "Product: ${state.product.name}"),
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
                                        title: state.product.name,
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
                                                title: state.product.id.toString(),
                                                fawesome: FontAwesomeIcons.listOl,
                                              ),
                                              ItemExtended(
                                                input: "Name",
                                                title: state.product.name,
                                                fawesome: FontAwesomeIcons.carrot,
                                                onTap: () => {
                                                  navigate(
                                                      context,
                                                      ProductUpdatePage(
                                                          id: state.id,
                                                          title: "Product name",
                                                          value: state.product.name,
                                                          type: "name"))
                                                },
                                              ),
                                              ItemExtended(
                                                input: "Description",
                                                title: state.product.description,
                                                fawesome: FontAwesomeIcons.fileLines,
                                                onTap: () => {
                                                  navigate(
                                                      context,
                                                      ProductUpdatePage(
                                                          id: state.id,
                                                          title: "Description",
                                                          value: state.product.description,
                                                          type: "description"))
                                                },
                                              ),
                                              ItemDep(
                                                title: "Variants",
                                                fawesome: FontAwesomeIcons.burger,
                                                onTap: () =>
                                                    {navigate(context, VariantListPage(product: state.product.id))},
                                              ),
                                              ItemDep(
                                                title: "Collection id",
                                                fawesome: FontAwesomeIcons.folderOpen,
                                                onTap: () => {
                                                  navigate(context, CollectionInfoPage(id: state.product.collection))
                                                },
                                              ),
                                              ItemDep(
                                                  title: "Delete",
                                                  fawesome: FontAwesomeIcons.xmark,
                                                  onTap: () => {
                                                        navigate(
                                                            context,
                                                            DeleteProductConfirmPage(
                                                              id: state.product.id,
                                                            ))
                                                      }),
                                            ]))),
                              ],
                            ),
                          )))));
      }
    });
  }
}
