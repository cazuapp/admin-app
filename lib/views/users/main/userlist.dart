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
import 'package:cazuapp_admin/bloc/user_menu/list/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/views/users/main/search.dart';
import 'package:cazuapp_admin/views/users/main/search_results.dart';
import 'package:cazuapp_admin/views/users/userlist.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* UserListPage is basically a page that displays all users*/

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                UserMenuListBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(UserFetch()))
      ],
      child: const UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => UserListStatePage();
}

class UserListStatePage extends State<UserList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onHomeScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<UserMenuListBloc, UserListState>(builder: (context, state) {
      switch (state.status) {
        case UserListStatus.initial:
          return const Loader();

        case UserListStatus.loading:
          return const Loader();
        case UserListStatus.failure:
          return const FailurePage(title: "User list", subtitle: "Error loading users");
        case UserListStatus.success:
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
                              child: UserSearchBar(
                                title: "Search",
                                onTap: () {
                                  navigate(context, const UserSearchPage());
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
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [utext(title: "Listing users", fontWeight: FontWeight.w500, fontSize: 20)],
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
                                    children: <Widget>[
                                      index >= state.users.length
                                          ? const SizedBox.shrink()
                                          : UserListItem(user: state.users[index]),
                                    ],
                                  );
                                },
                                itemCount: state.hasReachedMax ? state.users.length : state.users.length + 1,
                                controller: _scrollController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
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
      context.read<UserMenuListBloc>().add(UserFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
