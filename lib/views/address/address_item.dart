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

import 'package:cazuapp_admin/models/address.dart';
import 'package:cazuapp_admin/views/address/address_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/utext.dart';
import '../../../core/theme.dart';

class AddressListItem extends StatelessWidget {
  const AddressListItem({required this.address, required this.user, super.key});
  final Address address;
  final int user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            color: AppTheme.mainbg,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Stack(children: <Widget>[
              GestureDetector(
                  child: ListTile(
                      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                      onTap: () => {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) => AddressDataPage(id: address.id, user: user)))
                          },
                      subtitle: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            style: GoogleFonts.ubuntu(
                                fontSize: 15.0, color: const Color.fromARGB(221, 0, 0, 0), fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                  text: address.address.value,
                                  style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 15)),
                              const TextSpan(text: ", "),
                              TextSpan(
                                  text: address.city.value,
                                  style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 15)),
                              const TextSpan(text: ", "),
                              TextSpan(
                                  text: address.zip.value,
                                  style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 15)),
                            ],
                          )),
                      leading: const Icon(FontAwesomeIcons.locationArrow, color: AppTheme.iconcolors),
                      trailing: const Icon(Icons.navigate_next_sharp, color: AppTheme.rightarrow),
                      title: utext(
                          title: address.name.value,
                          fontSize: 15.0,
                          color: AppTheme.darkgray,
                          fontWeight: FontWeight.w700)))
            ])));
  }
}
