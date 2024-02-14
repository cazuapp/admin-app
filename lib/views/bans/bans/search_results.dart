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

import 'package:cazuapp_admin/bloc/bans/bans_search/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/bans/banlist.dart';
import 'package:cazuapp_admin/views/bans/bans/final_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanSearchPage extends StatelessWidget {
  const BanSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                BanSearchBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(SearchReset()))
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
    return BlocBuilder<BanSearchBloc, BanSearchState>(builder: (context, state) {
      switch (state.status) {
        case BanSearchStatus.initial:
          return const Loader();

        case BanSearchStatus.loading:
          return const Loader();
        case BanSearchStatus.failure:
          return const FailurePage(title: "Ban list", subtitle: "Error loading bans");
        case BanSearchStatus.success:
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
                                padding: EdgeInsets.only(
                                    top: size.width * 0.03,
                                    bottom: size.height * 0.02,
                                    left: size.height * 0.03,
                                    right: size.height * 0.03),
                                child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0)),
                                    ),
                                    child: const FinalBanSearchBar())),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.03,
                                    bottom: size.height * 0.02,
                                    left: size.height * 0.03,
                                    right: size.height * 0.02),
                                child: Column(children: <Widget>[
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    state.text.isNotEmpty
                                        ? utext(
                                            title: "Ban Results for ${state.text}",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20)
                                        : const SizedBox.shrink()
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
                                          index >= state.bans.length
                                              ? const SizedBox.shrink()
                                              : UserBanListItem(ban: state.bans[index]),
                                          index != state.bans.length
                                              ? const Divider(
                                                  color: AppTheme.fbackground,
                                                  height: 5,
                                                  thickness: 1,
                                                )
                                              : const SizedBox.shrink(),
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
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<BanSearchBloc>().add(OnScroll());
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
