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

import 'package:cazuapp_admin/bloc/products/lister/main/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/appear.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/lister/products/product_list_item.dart';
import 'package:cazuapp_admin/views/lister/products/search.dart';
import 'package:cazuapp_admin/views/lister/products/search_results.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* ProductListPage is basically a page that displays products in the system */

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key, this.collection = 0, this.pick = false});

  final int collection;
  final bool pick;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ProductListBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(SetCollection(collection: collection))
              ..add(SetPick(pick: pick))
              ..add(ListFetch()))
      ],
      child: const ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  final _scrollController = ScrollController();

  String title = "Product list";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductListBloc, ListState>(builder: (context, state) {
      switch (state.status) {
        case ListStatus.initial:
          return const Loader();

        case ListStatus.loading:
          return const Loader();
        case ListStatus.failure:
          return FailurePage(title: title, subtitle: "Error loading products");
        case ListStatus.success:
          /* Main scaffold for the success state */
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              elevation: 6.0, // Set the desired shadow elevation
              backgroundColor: AppTheme.shallowlockeye,
              onPressed: () {
                context.read<ProductListBloc>().add(Init());
                context.read<ProductListBloc>().add(ListFetch());
              },
              child: const Icon(Icons.refresh, color: AppTheme.white),
            ),
            appBar: null,
            backgroundColor: AppTheme.white,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              child: SafeArea(
                child: SizedBox(
                  height: size.height,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          height: size.height / 16,
                          width: size.width * 0.90,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0)),
                          ),
                          child: ProductListSearchBar(
                            title: "Search",
                            onTap: () {
                              appear(
                                context,
                                ProductSearchPage(collection: state.collection, pick: state.pick),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.03,
                          bottom: size.height * 0.02,
                          left: size.height * 0.03,
                          right: size.height * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                state.collection == 0
                                    ? utext(title: "Products", fontWeight: FontWeight.w500, fontSize: 20)
                                    : utext(
                                        title:
                                            "Products of collection #${state.collection} (${state.products[0].collectionTitle})",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                              ],
                            ),
                            utext(
                              title: "${state.total.toString()} in total",
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          thickness: 7,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  index >= state.products.length
                                      ? const SizedBox.shrink()
                                      : ProductListItemDisplay(product: state.products[index], pick: state.pick),
                                ],
                              );
                            },
                            itemCount: state.hasReachedMax ? state.products.length : state.products.length + 1,
                            controller: _scrollController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        // ... (unchanged)
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductListBloc>().add(ListFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
