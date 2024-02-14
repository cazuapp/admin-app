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

import 'package:cazuapp_admin/bloc/collections/lister/main/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/lister/collections/collection_list_item.dart';
import 'package:cazuapp_admin/views/lister/collections/search.dart';
import 'package:cazuapp_admin/views/lister/collections/search_results.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* CollectionListPage is basically a page that displays variants in the system */

class CollectionListPage extends StatelessWidget {
  const CollectionListPage({super.key, this.pick = false});
  final bool pick;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => CollectionListBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(SetPick(pick: pick))
              ..add(ListFetch()))
      ],
      child: const CollectionList(),
    );
  }
}

class CollectionList extends StatefulWidget {
  const CollectionList({super.key});

  @override
  State<CollectionList> createState() => CollectionListState();
}

class CollectionListState extends State<CollectionList> {
  final _scrollController = ScrollController();

  String title = "Collection list";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<CollectionListBloc, ListState>(builder: (context, state) {
      switch (state.status) {
        case ListStatus.initial:
          return const Loader();

        case ListStatus.loading:
          return const Loader();
        case ListStatus.failure:
          return FailurePage(title: title, subtitle: "Error loading collections");
        case ListStatus.success:
          return Scaffold(
              floatingActionButton: state.param == Param.all
                  ? FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              topLeft: Radius.circular(50))),
                      elevation: 25.0,
                      backgroundColor: AppTheme.shallowlockeye,
                      onPressed: () {
                        context.read<CollectionListBloc>().add(Init());

                        context.read<CollectionListBloc>().add(ListFetch());
                      },
                      child: const Icon(Icons.refresh, color: AppTheme.white))
                  : null,
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
                                    child: CollectionSearchBar(
                                      title: "Search",
                                      ontap: () => {navigate(context, CollectionSearchPage(pick: state.pick))},
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.03,
                                    bottom: size.height * 0.02,
                                    left: size.height * 0.03,
                                    right: size.height * 0.04),
                                child: Column(children: <Widget>[
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    utext(title: "Collections", fontWeight: FontWeight.w500, fontSize: 20)
                                  ]),
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
                                          index >= state.collections.length
                                              ? const SizedBox.shrink()
                                              : CollectionListItemDisplay(
                                                  collection: state.collections[index], pick: state.pick),
                                        ]);
                                      },
                                      itemCount:
                                          state.hasReachedMax ? state.collections.length : state.collections.length + 1,
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
      context.read<CollectionListBloc>().add(ListFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
