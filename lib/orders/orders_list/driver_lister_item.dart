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
import 'package:cazuapp_admin/bloc/user/user_manager/bloc.dart';
import 'package:cazuapp_admin/components/alerts.dart';
import 'package:cazuapp_admin/components/divisor.dart';
import 'package:cazuapp_admin/components/item_extended.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/models/order_info.dart';
import 'package:cazuapp_admin/models/user.dart';
import 'package:cazuapp_admin/views/orders/order_info.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DriverListerItem extends StatelessWidget {
  const DriverListerItem({required this.order, required this.divisor, required this.user, super.key});

  final OrderInfo order;
  final bool divisor;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance),
      child: CloseAddressForm(user: user, divisor: divisor, order: order),
    );
  }
}

class CloseAddressForm extends StatelessWidget {
  const CloseAddressForm({required this.user, required this.divisor, required this.order, super.key});
  final User user;
  final bool divisor;
  final OrderInfo order;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    bool show = true;

    if (user.id == order.driver) {
      show = false;
    }

    return BlocListener<UserManagerBloc, UserManagerState>(listener: (context, state) {
      if (state.current == UserStatus.failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildAlert(state.errmsg));
      } else {
        if (state.current == UserStatus.success) {
          Navigator.of(context).canPop() ? Navigator.pop(context) : null;
          Navigator.of(context).canPop() ? Navigator.pop(context) : null;
          Navigator.of(context).canPop() ? Navigator.pop(context) : null;

          navigate(context, OrderInfoPage(id: order.id, userid: user.id));
        }
      }
    }, child: BlocBuilder<UserManagerBloc, UserManagerState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
        child: Column(children: [
          ItemExtended(
            input: "${user.first} ${user.last} ",
            title: "User ID: ${user.id.toString()} ${!show ? ("(current)") : ""}",
            fawesome: FontAwesomeIcons.store,
            onTap: show
                ? () {
                    context.read<UserManagerBloc>().add(AssignOrder(order: order.id, user: user.id));
                  }
                : null,
          ),
          divisor ? const AppDivisor(top: 16) : const SizedBox.shrink(),
        ]),
      );
    }));
  }
}
