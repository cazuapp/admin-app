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
import 'package:cazuapp_admin/models/ban.dart';
import 'package:cazuapp_admin/views/users/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BanListDisplay extends StatelessWidget {
  const BanListDisplay({required this.ban, super.key});

  final BanListItem ban;

  @override
  Widget build(BuildContext context) {
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
                height: ScreenUtil().scaleHeight * 120,
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: InkWell(
                    onTap: () => {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(builder: (_) => UserDataPage(id: ban.userid)))
                        },
                    child: Column(children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          const Icon(Icons.person, color: AppTheme.black, size: 18),
                          utext(
                              title: "${ban.first} ${ban.last}",
                              color: AppTheme.black,
                              fontWeight: FontWeight.w500,
                              resize: true),
                        ]),
                      ]),
                      const Divider(),
                      const SizedBox(height: 2),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          const Icon(FontAwesomeIcons.listOl, color: AppTheme.darkgray, size: 18),
                          const SizedBox(width: 2),
                          utext(title: "Code: ${ban.code.toString()} ", resize: true),
                        ]),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        const Icon(FontAwesomeIcons.calendar, color: AppTheme.darkgray, size: 18),
                        const SizedBox(width: 2),
                        utext(title: " ${Etc.prettydate(ban.createdat)}", resize: true),
                      ]),
                    ])))));
  }
}
