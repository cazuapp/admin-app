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

import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/models/order_list.dart';
import 'package:cazuapp_admin/views/orders/order_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({required this.order, required this.current, super.key});

  final OrderList order;
  final String current;

  @override
  Widget build(BuildContext context) {
    var id = order.id.toString();
    var display = "pending";
    Color displayclr = Colors.black;

    switch (order.orderStatus) {
      case "pending":
        display = "Pending";
        displayclr = AppTheme.orange;
        break;

      case "ok":
        display = "ok";
        displayclr = AppTheme.focussecondary;
        break;

      case "delivered":
        display = "Delivered";
        displayclr = AppTheme.secondary;
        break;

      case "nodriver":
        display = "Unable to match driver";
        displayclr = AppTheme.alert;

        break;

      case "cancelled":
        display = "Cancelled";
        displayclr = AppTheme.softred;
        break;

      case "active":
        display = "";
        displayclr = AppTheme.focussecondary;

        break;

      default:
        display = "Error";
        displayclr = AppTheme.alert;

        break;
    }

    var finaldisplay = "";
    if (current == "Active") {
      finaldisplay = "Order: #${id.toString()}";
    } else {
      finaldisplay = "Order: #${id.toString()} ($display)";
    }

    return InkWell(
        child: Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.mainbg,
                  border: Border.all(
                      color: AppTheme.yesArrow, // Set border color
                      width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                height: ScreenUtil().scaleHeight * 140,
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: InkWell(
                    onTap: () => {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(builder: (_) => OrderInfoPage(id: order.id, userid: order.userid)))
                        },
                    child: Column(children: <Widget>[
                      /* We create a row in order to space icons and final display text in between */
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Icon(Icons.numbers, color: displayclr, size: 18),
                          utext(title: finaldisplay, color: displayclr, fontWeight: FontWeight.w500, resize: true),
                        ]),
                      ]),
                      const SizedBox(height: 2),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        const Icon(FontAwesomeIcons.locationDot, color: AppTheme.darkgray, size: 18),
                        const SizedBox(width: 2),
                        utext(title: "${order.address}, ${order.zip}", fontWeight: FontWeight.w500, resize: true),
                      ]),
                      const SizedBox(height: 3),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        const Icon(FontAwesomeIcons.locationArrow, color: AppTheme.darkgray, size: 18),
                        const SizedBox(width: 3),
                        utext(title: order.city, fontWeight: FontWeight.w500, resize: true),
                      ]),
                      const Divider(),
                      const SizedBox(height: 2),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          const Icon(FontAwesomeIcons.calendar, color: AppTheme.darkgray, size: 18),
                          const SizedBox(width: 2),
                          utext(title: " ${Etc.prettydate(order.created)}", resize: true),
                        ]),
                        const Icon(FontAwesomeIcons.rightLong, color: AppTheme.primarycolor)
                      ]),
                    ])))));
  }
}
