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

import 'package:cazuapp_admin/bloc/bans/bans/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/bans/banlist.dart';
import 'package:cazuapp_admin/views/bans/bans/search.dart';
import 'package:cazuapp_admin/views/bans/bans/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* BansPage is basically a page that displays pending orders */

class BansHomePage extends StatelessWidget {
  const BansHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /* We retrieve all bans on page opening */
        BlocProvider(
            create: (_) =>
                BansHomeBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(BansHomeFetch()))
      ],
      child: const BansHomeList(),
    );
  }
}

class BansHomeList extends StatefulWidget {
  const BansHomeList({super.key});

  @override
  State<BansHomeList> createState() => BansHomeListDisplay();
}

class BansHomeListDisplay extends State<BansHomeList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onHomeScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BansHomeBloc, BansHomeState>(builder: (context, state) {
      switch (state.status) {
        case BanHomeStatus.initial:
          return const Loader();

        case BanHomeStatus.loading:
          return const Loader();
        case BanHomeStatus.failure:
          return const FailurePage(title: "Bans list", subtitle: "Error loading bans");
        case BanHomeStatus.success:
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
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                    height: size.height / 16,
                                    width: size.width * 0.90,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0)),
                                    ),
                                    /* Search button widget */
                                    child: BanSearchBar(
                                      title: state.text.isEmpty ? "Search" : "",
                                      ontap: () => {navigate(context, const BanSearchPage())},
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.02,
                                    bottom: size.height * 0.01,
                                    left: size.height * 0.03,
                                    right: size.height * 0.0),
                                child: Column(children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [utext(title: "Ban list", fontWeight: FontWeight.w500, fontSize: 20)]),
                                  utext(
                                      title: "${state.total.toString()} in total",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16)
                                ])),
                            Expanded(
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    thickness: 7,
                                    child: ListView.builder(
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(children: <Widget>[
                                          index >= state.bans.length
                                              ? const SizedBox.shrink()
                                              : UserBanListItem(ban: state.bans[index]),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax ? state.bans.length : state.bans.length + 1,
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
      context.read<BansHomeBloc>().add(OnHomeScroll());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
