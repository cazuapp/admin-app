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

import 'package:cazuapp_admin/bloc/home/home/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/appear.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/home/home_list_item.dart';
import 'package:cazuapp_admin/views/home/search.dart';
import 'package:cazuapp_admin/views/home/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* HomePage is basically a page that displays pending orders */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /* We retrieve pending items on page opening */
        BlocProvider(
            create: (_) => HomeBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(HomeFetch()))
      ],
      child: const HomeList(),
    );
  }
}

class HomeList extends StatefulWidget {
  const HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  var title = "Orders list";

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      switch (state.status) {
        case HomeStatus.initial:
          return const Loader();

        case HomeStatus.loading:
          return const Loader();
        case HomeStatus.failure:
          return FailurePage(title: title, subtitle: "Error loading orders");
        case HomeStatus.success:
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
                  context.read<HomeBloc>().add(Init());
                  context.read<HomeBloc>().add(HomeFetch());
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
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                    height: size.height / 16,
                                    width: size.width * 0.90,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0)),
                                    ),
                                    /* Search button widget */
                                    child: HomeSearchBar(
                                        title: state.text.isEmpty ? "Search" : "",
                                        onTap: () => {appear(context, const SearchPage())}))),
                            Padding(
                                padding: EdgeInsets.only(
                                  top: size.width * 0.03,
                                  bottom: size.height * 0.02,
                                  left: size.height * 0.03,
                                  right: size.height * 0.04,
                                ),
                                child: Column(children: <Widget>[
                                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    utext(title: "Pending orders", fontWeight: FontWeight.w500, fontSize: 20),
                                    utext(
                                      title: "${state.total.toString()} in total",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                    ),
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
      context.read<HomeBloc>().add(HomeFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
