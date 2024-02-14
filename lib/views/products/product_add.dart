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

import 'dart:developer';

import 'package:cazuapp_admin/bloc/products/add/bloc.dart';
import 'package:cazuapp_admin/bloc/products/add/state.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/views/lister/collections/collections_list.dart';
import 'package:cazuapp_admin/views/products/product_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';

/* Page used to add a new product */

class ProductAddPage extends StatelessWidget {
  const ProductAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProductAddBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance),
        child: const ProductDataForm(),
      ),
    );
  }
}

class ProductDataForm extends StatelessWidget {
  const ProductDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<ProductAddBloc, ProductAddState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));

            context.read<ProductAddBloc>().add(ProductOK());
          } else if (state.status.isSuccess) {
            log("Adding new product ID: ${state.id}");
            Navigator.of(context).canPop() ? Navigator.pop(context) : null;
            Navigator.of(context).canPop() ? Navigator.pop(context) : null;

            Navigator.of(context).canPop() ? Navigator.pop(context) : null;
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductInfoPage(id: state.id)));
          }
        },
        child: Scaffold(
            backgroundColor: AppTheme.background,
            appBar: const TopBar(title: "Product add"),
            body: SafeArea(
                child: SizedBox(
                    height: size.height,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              SizedBox(
                                height: ScreenUtil().scaleHeight * 50,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                                    child: utext(
                                        fontSize: 14,
                                        title: "Product details",
                                        color: AppTheme.title,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(height: 6),
                              const Expanded(
                                  flex: 0,
                                  child: Column(children: [
                                    SizedBox(height: 2),
                                    Expanded(
                                      flex: 0,
                                      child: Column(
                                        children: [
                                          BuildName(),
                                          SizedBox(height: 10),
                                          BuildDescription(),
                                          SizedBox(height: 16),
                                          BuildPiority(),
                                          SizedBox(height: 16),
                                          BuildCollections(),
                                          SizedBox(height: 16),
                                          AddButton(),
                                        ],
                                      ),
                                    ),
                                  ])),
                            ])))))));
  }
}

class BuildCollections extends StatelessWidget {
  const BuildCollections({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductAddBloc, ProductAddState>(
      builder: (context, state) {
        return InkWell(onTap: () async {
          await navigate(context, const CollectionListPage(pick: true)).then((result) {
            if (result?.model != null && result?.model2 != null) {
              BlocProvider.of<ProductAddBloc>(context)
                  .add(SetCollection(collection: result?.model, collectionName: result?.model2));
            }
          });
        }, child: BlocBuilder<ProductAddBloc, ProductAddState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.centerRight, // Align the content to the right
              height: size.height / 14,
              width: size.width / 1.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: AppTheme.fbackground,
                border: Border.all(color: AppTheme.darkset),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add space between icons and text
                  children: <Widget>[
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.carrot, color: AppTheme.rightarrow, size: 17),
                        const SizedBox(width: 14),
                        state.collection > 0
                            ? utext(title: state.collectionName)
                            : utext(
                                title: "Collection",
                              ),
                      ],
                    ),
                    const Icon(Icons.navigate_next_sharp, color: AppTheme.rightarrow),
                  ],
                ),
              ),
            );
          },
        ));
      },
    );
  }
}

class BuildPiority extends StatelessWidget {
  const BuildPiority({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductAddBloc, ProductAddState>(
      buildWhen: (previous, current) => previous.model.description != current.model.description,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                const Icon(FontAwesomeIcons.listOl, color: AppTheme.rightarrow, size: 17),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    key: const Key('piorityForm_firstInput_textField'),
                    onChanged: (piority) =>
                        context.read<ProductAddBloc>().add(ProductPiorityChanged(int.parse(piority))),
                    maxLines: 1,
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.ubuntu(
                      fontSize: 14.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Piority',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ])),
        );
      },
    );
  }
}

class BuildName extends StatelessWidget {
  const BuildName({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductAddBloc, ProductAddState>(
      buildWhen: (previous, current) => previous.model.name != current.model.name,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                const Icon(FontAwesomeIcons.solidNoteSticky, color: AppTheme.rightarrow, size: 17),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    key: const Key('titleorm_firstInput_textField'),
                    onChanged: (name) => context.read<ProductAddBloc>().add(ProductNameChanged(name)),
                    maxLines: 1,
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.ubuntu(
                      fontSize: 14.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ])),
        );
      },
    );
  }
}

class BuildDescription extends StatelessWidget {
  const BuildDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductAddBloc, ProductAddState>(
      buildWhen: (previous, current) => previous.model.description != current.model.description,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                const Icon(FontAwesomeIcons.textWidth, color: AppTheme.rightarrow, size: 17),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    key: const Key('descriptionForm_firstInput_textField'),
                    onChanged: (name) => context.read<ProductAddBloc>().add(ProductDescriptionChanged(name)),
                    maxLines: 1,
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.ubuntu(
                      fontSize: 14.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ])),
        );
      },
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductAddBloc, ProductAddState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: size.height / 14,
                width: size.width / 1.4,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          elevation: 4.0,
                          backgroundColor: AppTheme.primarycolor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        key: const Key('addForm_continue_raisedButton'),
                        onPressed: state.isValid
                            ? () {
                                context.read<ProductAddBloc>().add(const ProductAddSubmitted());
                              }
                            : null,
                        child: utext(
                            title: "Create",
                            textAlign: TextAlign.center,
                            align: Alignment.center,
                            fontWeight: FontWeight.w500,
                            color: !state.isValid ? AppTheme.yesArrow : AppTheme.mainbg))));
      },
    );
  }
}
