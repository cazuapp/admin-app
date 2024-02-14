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

import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/bloc/variants/lister/search/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/lister/variants/final_search.dart';
import 'package:cazuapp_admin/views/lister/variants/variant_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VariantSearchPage extends StatelessWidget {
  const VariantSearchPage({super.key, this.product = 0});

  final int product;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => VariantSearchBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(SetProduct(product: product))
              ..add(SearchReset()))
      ],
      child: const SearchList(),
    );
  }
}

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final _scrollController = ScrollController();

  bool isBottom = false;

  void _toggle(bool sett) {
    setState(() {
      if (isBottom == sett) {
        return;
      }

      isBottom = sett;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<VariantSearchBloc, VariantSearchState>(builder: (context, state) {
      switch (state.status) {
        case VariantSearchStatus.initial:
          return const Loader();

        case VariantSearchStatus.loading:
          return const Loader();
        case VariantSearchStatus.failure:
          return const FailurePage(title: "Variant list", subtitle: "Error loading variants");
        case VariantSearchStatus.success:
          return Scaffold(
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
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 10),
                                child: Container(
                                    height: size.height / 16,
                                    width: size.width * 0.90,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    /* Search button widget */
                                    child: const FinalSearchBar())),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.02,
                                    bottom: size.height * 0.02,
                                    left: size.height * 0.03,
                                    right: size.height * 0.03),
                                child: Column(children: <Widget>[
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    state.text.isEmpty
                                        ? const SizedBox.shrink()
                                        : state.product == 0
                                            ? utext(
                                                title: "Results for ${state.text}",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20)
                                            : utext(
                                                title: "Results for ${state.text} on product #${state.product}",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20)
                                  ]),
                                  state.text.isNotEmpty
                                      ? utext(
                                          title: "${state.total.toString()} in total",
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16)
                                      : const SizedBox.shrink()
                                ])),
                            Expanded(
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    thickness: 7,
                                    child: ListView.builder(
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(children: <Widget>[
                                          index >= state.variants.length
                                              ? const SizedBox.shrink()
                                              : VariantListItemDisplay(variant: state.variants[index]),
                                        ]);
                                      },
                                      itemCount:
                                          state.hasReachedMax ? state.variants.length : state.variants.length + 1,
                                      controller: _scrollController,
                                    )))
                          ])))));
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<VariantSearchBloc>().add(OnScroll());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (currentScroll <= 0.9) {
      _toggle(false);
    } else {
      _toggle(true);
    }
    return currentScroll >= (maxScroll * 0.9);
  }
}
