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

import 'package:cazuapp_admin/bloc/variants/lister/search/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme.dart';

class FinalSearchBar extends StatefulWidget {
  const FinalSearchBar({super.key});

  @override
  State<FinalSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<FinalSearchBar> {
  final _textController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VariantSearchBloc, VariantSearchState>(
      buildWhen: (previous, current) => previous.text != current.text,
      builder: (context, state) {
        return Row(
          children: <Widget>[
            backButton(context),
            const SizedBox(width: 20.0),
            Expanded(child: searchBar()),
          ],
        );
      },
    );
  }

  Widget backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        FontAwesomeIcons.alignLeft,
        size: 25,
        color: AppTheme.darkgray,
      ),
    );
  }

  Widget searchBar() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          colors: [Colors.grey[200]!, Colors.grey[200]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12.0)),
        child: searchInputField(),
      ),
    );
  }

  Widget searchInputField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.search, color: Colors.black),
        SizedBox(width: ScreenUtil().setWidth(10)),
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            controller: _textController,
            key: const Key('fsearchBar_textField'),
            onChanged: (text) => _handleSearchTextChange(context, text),
            maxLines: 1,
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            style: GoogleFonts.ubuntu(
              fontSize: ScreenUtil().setSp(14.0),
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              hintText: '',
              suffixIcon: clearButton(),
              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding
            ),
          ),
        ),
      ],
    );
  }

  Widget clearButton() {
    return InkWell(
      onTap: () {
        _textController.clear();
        BlocProvider.of<VariantSearchBloc>(context).add(SearchReset());
      },
      child: Icon(
        FontAwesomeIcons.xmark,
        size: 25,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }

  void _handleSearchTextChange(BuildContext context, String text) {
    BlocProvider.of<VariantSearchBloc>(context).add(SearchReset());
    if (text.isNotEmpty) {
      BlocProvider.of<VariantSearchBloc>(context).add(SearchRequest(text: text));
    }
  }
}
