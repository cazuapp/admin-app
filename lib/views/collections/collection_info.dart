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

import 'package:cazuapp_admin/bloc/collections/info/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/item_dep.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/views/collections/collection_update.dart';
import 'package:cazuapp_admin/views/collections/confirm_delete.dart';
import 'package:cazuapp_admin/views/lister/products/products_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class CollectionInfoPage extends StatelessWidget {
  const CollectionInfoPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CollectionInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(FetchInfo(id: id)),
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

    return BlocBuilder<CollectionInfoBloc, CollectionInfoState>(builder: (context, state) {
      switch (state.status) {
        case CollectionInfoStatus.deleted:
          return const Loader();
        case CollectionInfoStatus.initial:
          return const Loader();
        case CollectionInfoStatus.loading:
          return const Loader();

        case CollectionInfoStatus.failure:
          return const FailurePage(title: "Collection info", subtitle: "Failed to retrieve collection information");

        case CollectionInfoStatus.success:
          return Scaffold(
              backgroundColor: AppTheme.background,
              appBar: TopBar(title: "Collection: ${state.collection.title}"),
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
                                        title: state.collection.title,
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
                                                title: state.collection.id.toString(),
                                                fawesome: FontAwesomeIcons.listOl,
                                              ),
                                              ItemExtended(
                                                input: "Name",
                                                title: state.collection.title,
                                                fawesome: FontAwesomeIcons.folderOpen,
                                                onTap: () => {
                                                  navigate(
                                                      context,
                                                      CollectionUpdatePage(
                                                          id: state.id,
                                                          title: "Collection title",
                                                          value: state.collection.title,
                                                          type: "title"))
                                                },
                                              ),
                                              ItemDep(
                                                title: "Products",
                                                fawesome: FontAwesomeIcons.carrot,
                                                onTap: () => {
                                                  navigate(context, ProductListPage(collection: state.collection.id))
                                                },
                                              ),
                                              ItemExtended(
                                                input: "Piority",
                                                title: state.collection.piority.toString(),
                                                fawesome: FontAwesomeIcons.starHalfStroke,
                                                onTap: () => {
                                                  navigate(
                                                      context,
                                                      CollectionUpdatePage(
                                                          id: state.id,
                                                          title: "Collection piority",
                                                          value: state.collection.id.toString(),
                                                          type: "piority"))
                                                },
                                              ),
                                              ItemDep(
                                                  title: "Delete",
                                                  fawesome: FontAwesomeIcons.xmark,
                                                  onTap: () => {
                                                        navigate(
                                                            context,
                                                            DeleteCollectionConfirmPage(
                                                              id: state.collection.id,
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
