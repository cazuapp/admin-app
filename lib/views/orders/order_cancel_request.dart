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
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/models/order_info.dart';
import 'package:cazuapp_admin/views/orders/order_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/orders/orders_manager/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class OrderCancelPage extends StatelessWidget {
  final int id;
  final int userid;

  const OrderCancelPage({required this.id, required this.userid, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(OrderInfoRequest(id: id)),
        child: const CancelForm(),
      ),
    );
  }
}

class CancelForm extends StatelessWidget {
  const CancelForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final fixed = ScreenUtil().scaleHeight * 1.33;

    return BlocListener<OrderManagerBloc, OrderManagerState>(listener: (context, state) {
      if (state.current == OrderStatus.failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildAlert(state.errmsg));
      } else if (state.current == OrderStatus.cancelsuccess) {
        Navigator.pop(context);
        Navigator.pop(context);

        navigate(context, OrderInfoPage(id: state.info.id, userid: state.info.userid));
      }
    }, child: BlocBuilder<OrderManagerBloc, OrderManagerState>(builder: (context, state) {
      OrderInfo order = state.info;

      bool canCancel = false;

      if (order.deliverStatus == "pending" && order.orderStatus == "pending") {
        canCancel = true;
      }
      return Scaffold(
          backgroundColor: AppTheme.mainbg,
          appBar: TopBar(title: "Cancel order #${state.info.id}"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height / 1.5,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.xmark, size: 60, color: AppTheme.softred),
                            Expanded(
                                flex: 0,
                                child: Column(children: [
                                  SizedBox(height: fixed * 20),
                                  utext(
                                      title: "Order #${state.info.id}",
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.main,
                                      fontSize: 22,
                                      align: Alignment.center),
                                  SizedBox(height: fixed * 20),
                                  canCancel
                                      ? utext(
                                          textAlign: TextAlign.center,
                                          align: Alignment.center,
                                          title: "Do you really want to cancel your order?",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: const Color.fromARGB(159, 18, 18, 18),
                                        )
                                      : utext(
                                          textAlign: TextAlign.center,
                                          align: Alignment.center,
                                          title: "You can't cancel this order! ",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: const Color.fromARGB(159, 18, 18, 18)),
                                  const SizedBox(height: 25),
                                  canCancel ? const ConfirmButton() : const SizedBox.shrink(),
                                ]))
                          ])))));
    }));
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderManagerBloc, OrderManagerState>(
      builder: (context, state) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
                icon: const Icon(
                  FontAwesomeIcons.rightLong,
                  color: AppTheme.mainbg,
                  size: 19.0,
                ),
                label: utext(
                    title: "Cancel order",
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.mainbg),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 10.0,
                  backgroundColor: AppTheme.softred,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                key: const Key('signupForm_continue_raisedButton'),
                onPressed: () {
                  context
                      .read<OrderManagerBloc>()
                      .add(OrderCancelRequest(id: state.info.id, userid: state.info.userid));
                }));
      },
    );
  }
}
