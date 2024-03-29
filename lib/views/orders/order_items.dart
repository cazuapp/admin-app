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

import 'package:cazuapp_admin/bloc/orders/item_list/bloc.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:cazuapp_admin/views/orders/order_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/notfound.dart';
import '../../../components/progress.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';

class OrderItemsPage extends StatelessWidget {
  const OrderItemsPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderItemsBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance,
        )
          ..add(SetOrder(id: id))
          ..add(ItemsFetch()),
        child: const OrderItemsForm(),
      ),
    );
  }
}

class OrderItemsForm extends StatefulWidget {
  const OrderItemsForm({super.key});

  @override
  State<OrderItemsForm> createState() => _OrderItemsFormState();
}

class _OrderItemsFormState extends State<OrderItemsForm> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildDescription(OrderItemsState state) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          utext(title: "Items on order #${state.id}", color: AppTheme.main, fontWeight: FontWeight.w600),
          utext(title: "${state.total} in total", color: AppTheme.darkgray),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppTheme.white,
      child: Table(
        border: TableBorder.symmetric(
          outside: const BorderSide(width: 1, color: AppTheme.black, style: BorderStyle.solid),
          inside: const BorderSide(width: 1, color: AppTheme.black, style: BorderStyle.solid),
        ),
        children: [
          TableRow(
            children: [
              _buildTableCell("Item"),
              _buildTableCell("Quantity"),
              _buildTableCell("Price"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String title) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: utext(
        title: title,
        fontWeight: FontWeight.w600,
        align: Alignment.center,
      ),
    );
  }

  Widget _buildItemList(OrderItemsState state) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: false,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              if (index < state.items.length) OrderItemList(index: index, item: state.items[index]),
            ],
          );
        },
        itemCount: state.hasReachedMax ? state.items.length : state.items.length + 1,
        controller: _scrollController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<OrderItemsBloc, OrderItemsState>(
      builder: (context, state) {
        switch (state.status) {
          case OrderItemsStatus.initial:
          case OrderItemsStatus.loading:
            return const Loader();

          case OrderItemsStatus.failure:
            return const FailurePage(title: "Items list", subtitle: "Failed to retrieve item list.");

          case OrderItemsStatus.success:
            if (state.items.isEmpty) {
              return const NotFoundPage(title: "Item List", main: "You have not added any items.");
            }

            return Scaffold(
              backgroundColor: AppTheme.background,
              appBar: TopBar(title: "#${state.id}"),
              body: SafeArea(
                child: SizedBox(
                  height: size.height,
                  child: Stack(
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.only(top: 10), child: _buildDescription(state)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.00),
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
                            _buildTableHeader(),
                            _buildItemList(state),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<OrderItemsBloc>().add(ItemsFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
