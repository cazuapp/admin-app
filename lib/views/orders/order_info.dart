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

import 'package:cazuapp_admin/bloc/orders/orders_manager/bloc.dart';
import 'package:cazuapp_admin/bloc/user/user_manager/bloc.dart';
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/components/item_account.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/models/order_info.dart';
import 'package:cazuapp_admin/views/address/address_historic.dart';
import 'package:cazuapp_admin/views/lister/drivers/driverlist.dart';
import 'package:cazuapp_admin/views/orders/order_cancel_request.dart';
import 'package:cazuapp_admin/views/orders/order_items.dart';
import 'package:cazuapp_admin/views/users/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../bloc/user/auth/bloc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class OrderInfoPage extends StatelessWidget {
  const OrderInfoPage({super.key, required this.userid, required this.id});

  final int id;
  final int userid;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderManagerBloc>(
          create: (_) => OrderManagerBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance,
          )..add(OrderInfoRequest(id: id)),
        ),
        BlocProvider<UserManagerBloc>(
            create: (_) => UserManagerBloc(
                  instance: BlocProvider.of<AuthenticationBloc>(context).instance,
                )),
      ],
      child: const OrderInfoForm(),
    );
  }
}

class OrderInfoForm extends StatelessWidget {
  const OrderInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<OrderManagerBloc, OrderManagerState>(builder: (context, state) {
      bool canCancel = false;
      bool isCancelled = false;

      OrderInfo order = state.info;

      String display = "";
      if (order.deliverStatus == "pending" && order.orderStatus == "pending") {
        canCancel = true;
      }
      switch (order.orderStatus) {
        case "pending":
          display = "Pending";

          break;

        case "delivered":
          display = "Delivered";
          break;

        case "nodriver":
          display = "Unable to match driver";

          break;

        case "active":
          display = "";

          break;

        case "cancelled":
          isCancelled = true;
          display = "Cancelled";

          break;
        default:
          display = "Error";

          break;
      }

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: TopBar(title: "Order #${order.id.toString()}"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: "#${order.id.toString()}",
                                    color: AppTheme.title,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 6.h),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(width: 1, color: Colors.white)),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ItemExtended(
                                            input: "Assigned driver",
                                            title: state.info.driver > 0
                                                ? "${state.info.driverFirst} ${state.info.driverLast} : ID ${state.info.driver}"
                                                : "Nobody",
                                            fawesome: FontAwesomeIcons.store,
                                            onTap: () async {
                                              UserManagerBloc userManagerBloc =
                                                  BlocProvider.of<UserManagerBloc>(context);
                                              userManagerBloc.add(const Load());

                                              await navigate(context, const DriverListPage(pick: true)).then((result) {
                                                if (result?.model != null) {
                                                  userManagerBloc
                                                      .add(AssignOrder(order: order.id, user: result?.model));
                                                  Navigator.pop(context);
                                                }
                                              });
                                            },
                                          ),
                                          ItemExtended(
                                            input: "Placed by",
                                            title: "${order.userFirst} ${order.userLast}",
                                            fawesome: FontAwesomeIcons.user,
                                            onTap: () => {navigate(context, UserDataPage(id: state.info.userid))},
                                          ),
                                          ItemAccount(
                                              title: "View all items",
                                              fawesome: FontAwesomeIcons.list,
                                              onTap: () {
                                                navigate(context, OrderItemsPage(id: order.id));
                                              }),
                                          ItemExtended(
                                              input: "Address",
                                              title: order.addressName,
                                              fawesome: FontAwesomeIcons.locationDot,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => AddressHistoricDataPage(
                                                            id: order.id, userid: order.userid)));
                                              }),
                                          canCancel == true
                                              ? ItemAccount(
                                                  title: "Cancel order",
                                                  fawesome: FontAwesomeIcons.xmark,
                                                  onTap: () {
                                                    navigate(
                                                        context, OrderCancelPage(id: order.id, userid: order.userid));
                                                  })
                                              : const SizedBox.shrink(),
                                          ItemExtended(
                                            input: "Payment type",
                                            title: context
                                                .read<AuthenticationBloc>()
                                                .instance
                                                .payments
                                                .getValue(key: state.info.paymentType)
                                                ?.name
                                                .capitalize(),
                                            fawesome: FontAwesomeIcons.store,
                                          ),
                                          ItemExtended(
                                            red: isCancelled ? true : false,
                                            input: "Order status",
                                            title: display,
                                            fawesome: FontAwesomeIcons.arrowDownUpLock,
                                          ),
                                          !isCancelled
                                              ? ItemExtended(
                                                  input: "Deliver status",
                                                  title: order.deliverStatus.capitalize(),
                                                  fawesome: FontAwesomeIcons.info,
                                                )
                                              : const SizedBox.shrink(),
                                          ItemExtended(
                                            input: "Total",
                                            title: "\$${order.total.toString()}",
                                            fawesome: FontAwesomeIcons.moneyBillTrendUp,
                                          ),
                                          ItemExtended(
                                            input: "Shipping total",
                                            title: "\$${order.shipping.toString()}",
                                            fawesome: FontAwesomeIcons.moneyBillTransfer,
                                          ),
                                          ItemExtended(
                                            input: "Tax total",
                                            title: "\$${order.totaltax.toString()}",
                                            fawesome: FontAwesomeIcons.moneyBillTransfer,
                                          ),
                                          ItemExtended(
                                            input: "Total + taxes",
                                            title: "\$${order.totalTaxShipping.toString()}",
                                            fawesome: FontAwesomeIcons.moneyCheck,
                                          ),
                                        ]))),
                          ],
                        ),
                      )))));
    });
  }
}
