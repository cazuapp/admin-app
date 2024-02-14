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

import 'package:cazuapp_admin/bloc/admin/search/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';

class AdminSearchBar extends StatefulWidget {
  const AdminSearchBar({super.key});

  @override
  State<AdminSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<AdminSearchBar> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSearchBloc, AdminSearchState>(
        buildWhen: (previous, current) => previous.text != current.text,
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: AppTheme.settings, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      key: const Key('homeForm_emailInput_textField'),
                      controller: _textController,
                      onChanged: (text) {
                        if (text == '') {
                          _onClearTapped();
                          return;
                        }
                        BlocProvider.of<AdminSearchBloc>(context).add(SearchReset());
                        BlocProvider.of<AdminSearchBloc>(context).add(SearchRequest(text: text));
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.settings,
                          labelText: "Search",
                          labelStyle: const TextStyle(
                            color: AppTheme.yesArrow,
                            fontSize: 14,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          suffixIcon: _textController.text != ''
                              ? GestureDetector(
                                  onTap: _onClearTapped,
                                  child: const Icon(size: 18, FontAwesomeIcons.xmark, color: AppTheme.iconsSettings),
                                )
                              : null,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: AppTheme.darkset),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: AppTheme.fbackground),
                          ),
                          contentPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 5),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.iconsSettings)),
                    ),
                  ),
                ),
                //    const SizedBox(width: 20),
              ],
            ),
          );
        });
  }

  void _onClearTapped() {
    _textController.text = '';
    BlocProvider.of<AdminSearchBloc>(context).add(SearchReset());
    BlocProvider.of<AdminSearchBloc>(context).add(UserFetched());
  }
}
