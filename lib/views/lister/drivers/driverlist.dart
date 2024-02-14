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

import 'package:cazuapp_admin/bloc/drivers/list/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/appear.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/lister/drivers/search.dart';
import 'package:cazuapp_admin/views/lister/drivers/search_results.dart';

import 'package:cazuapp_admin/views/users/userlist.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* DriverListPage is basically a page that displays all drivers */

class DriverListPage extends StatelessWidget {
  const DriverListPage({super.key, this.pick = false});
  final bool pick;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => DriverMenuListBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(SetPick(pick: pick))
              ..add(DriverFetch()))
      ],
      child: const DriverList(),
    );
  }
}

class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => DriverListStatePage();
}

class DriverListStatePage extends State<DriverList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onHomeScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<DriverMenuListBloc, DriverListState>(builder: (context, state) {
      switch (state.status) {
        case DriverListStatus.initial:
          return const Loader();

        case DriverListStatus.loading:
          return const Loader();
        case DriverListStatus.failure:
          return const FailurePage(title: "Driver list", subtitle: "Error loading drivers");
        case DriverListStatus.success:
          return Scaffold(
              backgroundColor: AppTheme.white,
              appBar: null,
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
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                    height: size.height / 16,
                                    width: size.width * 0.90,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0)),
                                    ),
                                    child: DriverSearchBar(
                                        title: "Search",
                                        onTap: () => {appear(context, DriverSearchPage(pick: state.pick))}))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.03,
                                    bottom: size.height * 0.02,
                                    left: size.height * 0.03,
                                    right: size.height * 0.04),
                                child: Column(children: <Widget>[
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    utext(title: "Listing drivers", fontWeight: FontWeight.w500, fontSize: 20)
                                  ]),
                                  state.total > 0
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
                                          index >= state.users.length
                                              ? const SizedBox.shrink()
                                              : UserListItem(user: state.users[index], pick: state.pick),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax ? state.users.length : state.users.length + 1,
                                      controller: _scrollController,
                                    )))
                          ])))));
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onHomeScroll)
      ..dispose();
    super.dispose();
  }

  void _onHomeScroll() {
    if (_isBottom) {
      context.read<DriverMenuListBloc>().add(DriverFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
