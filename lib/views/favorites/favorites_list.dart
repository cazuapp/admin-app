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

import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/notfound.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:cazuapp_admin/views/favorites/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/favorites/favorite_list/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => FavoriteBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(UserSet(id: id))
          ..add(FavoritesFetched()),
        child: const ProductCollectionList(),
      ),
    );
  }
}

class ProductCollectionList extends StatefulWidget {
  const ProductCollectionList({super.key});
  @override
  State<ProductCollectionList> createState() => _ProductCollectionListState();
}

class _ProductCollectionListState extends State<ProductCollectionList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _description() {
    return BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
      int total = state.total;

      return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              utext(title: "All favorites", color: AppTheme.main, fontWeight: FontWeight.w600),
              const SizedBox(height: 2),
              utext(title: "$total in total", color: AppTheme.darkgray),
            ],
          ));
    });
  }

  Future<void> refresh() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixed = ScreenUtil().scaleHeight * 2.33;

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        switch (state.status) {
          case FavoriteStatus.loading:
            return const Loader();

          case FavoriteStatus.initial:
            return const SizedBox.shrink();
          case FavoriteStatus.failure:
            return const FailurePage(title: "Favorites", subtitle: "Failed to retrieve favorite list.");

          case FavoriteStatus.success:
            if (state.products.isEmpty) {
              return const NotFoundPage(title: "Favorites", main: "User does not have any favorite");
            }

            return Scaffold(
                backgroundColor: AppTheme.mainbg,
                appBar: const TopBar(title: "Favorites"),
                body: SafeArea(
                    child: SizedBox(
                        height: size.height,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  _description(),
                                ])),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.01, right: size.width * 0.01, top: fixed * 35.05),
                                child: Column(
                                  children: [
                                    SizedBox(height: fixed * 2.3),
                                    Expanded(
                                        child: Scrollbar(
                                            thumbVisibility: true,
                                            controller: _scrollController,
                                            thickness: 7,
                                            child: ListView.builder(
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(children: <Widget>[
                                                  index >= state.products.length
                                                      ? const SizedBox.shrink()
                                                      : ProductCollectionListItem(product: state.products[index]),
                                                ]);
                                              },
                                              itemCount: state.hasReachedMax
                                                  ? state.products.length
                                                  : state.products.length + 1,
                                              controller: _scrollController,
                                            ))),
                                    const SizedBox(height: 23),
                                  ],
                                ))
                          ],
                        ))));
        }
      },
    );
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
      context.read<FavoriteBloc>().add(FavoritesFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
