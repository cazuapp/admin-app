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
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/address/addresses/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/notfound.dart';
import '../../../components/progress.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';
import 'address_item.dart';

class AddressListPage extends StatelessWidget {
  const AddressListPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar;

    return Scaffold(
      body: BlocProvider(
        create: (_) => AddressBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(UserSet(id: id))
          ..add(AddressList()),
        child: const AddressListForm(),
      ),
    );
  }
}

class AddressListForm extends StatefulWidget {
  const AddressListForm({super.key});

  @override
  State<AddressListForm> createState() => _AddressManagerState();
}

class _AddressManagerState extends State<AddressListForm> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _description() {
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      int total = state.total;

      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              utext(title: "User's addresses", color: AppTheme.main, fontWeight: FontWeight.w600),
              const SizedBox(height: 2),
              utext(title: "$total in total", color: AppTheme.darkgray),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar;

    final size = MediaQuery.of(context).size;
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      switch (state.status) {
        case AddressStatus.initial:
          return const Loader();

        case AddressStatus.failure:
          return const FailurePage(title: "Address list", subtitle: "Failed to retrieve address list.");

        case AddressStatus.success:
          if (state.addresses.isEmpty) {
            return const NotFoundPage(title: "Address List", main: "User has not added any addresses.");
          }
          return Scaffold(
              appBar: const TopBar(title: "Address manager"),
              body: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Stack(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              _description(),
                            ])),
                        const SizedBox(height: 15),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 70),
                                Expanded(
                                    child: ListView.builder(
                                  shrinkWrap: false,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(children: <Widget>[
                                      const SizedBox(height: 13),
                                      index >= state.addresses.length
                                          ? const SizedBox.shrink()
                                          : AddressListItem(user: state.userid, address: state.addresses[index]),
                                    ]);
                                  },
                                  itemCount: state.hasReachedMax ? state.addresses.length : state.addresses.length + 1,
                                  controller: _scrollController,
                                )),
                                const SizedBox(height: 12),
                              ],
                            ))
                      ]))));
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
    if (_isBottom) context.read<AddressBloc>().add(AddressList());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
