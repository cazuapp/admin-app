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

import 'package:cazuapp_admin/components/divisor.dart';
import 'package:cazuapp_admin/models/user.dart';
import 'package:cazuapp_admin/views/users/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/utext.dart';
import '../../../core/theme.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({required this.user, required this.divisor, this.pop = false, super.key});
  final User user;
  final bool divisor;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
        child: Padding(
            padding: EdgeInsets.only(
                top: size.width * 0.05,
                bottom: size.height * 0.00,
                left: size.height * 0.02,
                right: size.height * 0.03),
            child: Container(
                color: AppTheme.mainbg,
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Column(children: <Widget>[
                  GestureDetector(
                      child: ListTile(
                          visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                          onTap: () => {
                                if (pop) {Navigator.pop(context)},
                                Navigator.of(context).push(
                                    CupertinoPageRoute(builder: (BuildContext context) => UserDataPage(id: user.id)))
                              },
                          subtitle: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: GoogleFonts.ubuntu(
                                    fontSize: 15.0,
                                    color: const Color.fromARGB(221, 0, 0, 0),
                                    fontWeight: FontWeight.w400),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: user.first,
                                      style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 15)),
                                  const TextSpan(text: " "),
                                  TextSpan(
                                      text: user.last,
                                      style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 15)),
                                ],
                              )),
                          leading: const Icon(FontAwesomeIcons.locationArrow, color: AppTheme.iconcolors),
                          trailing: const Icon(Icons.navigate_next_sharp, color: AppTheme.rightarrow),
                          title: utext(
                              title: user.email,
                              fontSize: 15.0,
                              color: AppTheme.darkgray,
                              fontWeight: FontWeight.w700))),
                  divisor ? const AppDivisor(top: 16) : const SizedBox.shrink(),
                ]))));
  }
}
