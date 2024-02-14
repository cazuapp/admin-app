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
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/models/ban.dart';
import 'package:cazuapp_admin/views/users/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserBanListItem extends StatelessWidget {
  const UserBanListItem({required this.ban, super.key});

  final BanListItem ban;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {navigate(context, UserDataPage(id: ban.userid))},
        child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().scaleHeight * 5,
              bottom: ScreenUtil().scaleHeight * 20,
              left: ScreenUtil().scaleWidth * 17,
              right: ScreenUtil().scaleWidth * 17,
            ),
            child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().scaleHeight * 10,
                  horizontal: ScreenUtil().screenWidth * 0.05,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.mainbg,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                height: ScreenUtil().scaleHeight * 140,
                child: InkWell(
                    child: Column(children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(height: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(Icons.email, color: AppTheme.primarycolor, size: 18),
                      const SizedBox(width: 5),
                      utext(title: ban.email, fontWeight: FontWeight.w500, resize: true),
                    ]),
                  ]),
                  Column(children: <Widget>[
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(FontAwesomeIcons.user, color: AppTheme.focuschill2, size: 18),
                      const SizedBox(width: 5),
                      utext(title: "${ban.first} + ${ban.last}", fontWeight: FontWeight.w500, resize: true),
                    ]),
                  ]),
                  const SizedBox(height: 15),
                  const Divider(),
                  Column(children: <Widget>[
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(FontAwesomeIcons.calendar, color: AppTheme.orange, size: 18),
                      const SizedBox(width: 5),
                      utext(title: Etc.fromBan(ban.code), fontWeight: FontWeight.w500, resize: true, shrink: false),
                    ]),
                  ]),
                ])))));
  }
}
