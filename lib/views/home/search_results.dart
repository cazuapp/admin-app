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

import 'package:cazuapp_admin/bloc/home/home_search/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/home/final_search.dart';
import 'package:cazuapp_admin/views/home/home_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                HomeSearchBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(SearchReset()))
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
    return BlocBuilder<HomeSearchBloc, HomeSearchState>(builder: (context, state) {
      switch (state.status) {
        case HomeSearchStatus.initial:
          return const Loader();

        case HomeSearchStatus.loading:
          return const Loader();
        case HomeSearchStatus.failure:
          return const FailurePage(title: "Orders list", subtitle: "Error loading orders");
        case HomeSearchStatus.success:
          return Scaffold(
              appBar: null,
              backgroundColor: AppTheme.white,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent, // transparent status bar
                    statusBarIconBrightness: Brightness.dark, // status bar icons' color
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
                                    top: size.width * 0.03,
                                    bottom: size.height * 0.02,
                                    left: size.height * 0.03,
                                    right: size.height * 0.04),
                                child: Column(children: <Widget>[
                                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    state.text.isNotEmpty
                                        ? utext(
                                            title: "Results for ${state.text}",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20)
                                        : const SizedBox.shrink(),
                                    state.text.isNotEmpty
                                        ? utext(
                                            title: "${state.total.toString()} in total",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                          )
                                        : const SizedBox.shrink(),
                                  ]),
                                ])),
                            Expanded(
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    thickness: 7,
                                    child: ListView.builder(
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(children: <Widget>[
                                          index >= state.orders.length
                                              ? const SizedBox.shrink()
                                              : HomeListItem(
                                                  order: state.orders[index], current: state.orders[index].orderStatus),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
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
      context.read<HomeSearchBloc>().add(OnScroll());
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
