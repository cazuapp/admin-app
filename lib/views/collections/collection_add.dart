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

import 'dart:io';
import 'dart:math';

import 'package:cazuapp_admin/bloc/collections/add/bloc.dart';
import 'package:cazuapp_admin/bloc/collections/add/state.dart';
import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/components/navigator.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:cazuapp_admin/views/collections/collection_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';

/* Used to add a new collection */

class CollectionAddPage extends StatelessWidget {
  const CollectionAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => CollectionAddBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance),
        child: const AddressDataForm());
  }
}

class AddressDataForm extends StatelessWidget {
  const AddressDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<CollectionAddBloc, CollectionAddState>(listener: (context, state) {
      if (state.status.isFailure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildAlert(state.errmsg));

        context.read<CollectionAddBloc>().add(CollectionOK());
      } else if (state.status.isSuccess) {
        Navigator.of(context).canPop() ? Navigator.pop(context) : null;
        Navigator.of(context).canPop() ? Navigator.pop(context) : null;

        Navigator.of(context).canPop() ? Navigator.pop(context) : null;
        navigate(context, CollectionInfoPage(id: state.id));
      }
    }, child: BlocBuilder<CollectionAddBloc, CollectionAddState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.white,
          appBar: const TopBar(title: "Collection add"),
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
                                      title: "Collection details",
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
                                        BuildTitle(),
                                        SizedBox(height: 10),
                                        BuildPiority(),
                                        SizedBox(height: 16),
                                        BuildImage(),
                                        SizedBox(height: 16),
                                        AddButton(),
                                      ],
                                    ),
                                  ),
                                ])),
                          ]))))));
    }));
  }
}

class BuildImage extends StatelessWidget {
  const BuildImage({super.key});

  Future<String?> getimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image.path;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final collectionAddBloc = context.read<CollectionAddBloc>();

    return BlocBuilder<CollectionAddBloc, CollectionAddState>(builder: (context, state) {
      return InkWell(onTap: () async {
        String? path = await getimage();

        if (path != null) {
          collectionAddBloc.add(SetImage(path: path));
        }
      }, child: BlocBuilder<CollectionAddBloc, CollectionAddState>(
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
                      const Icon(FontAwesomeIcons.cameraRetro, color: AppTheme.rightarrow, size: 17),
                      const SizedBox(width: 14),
                      state.image.isNotEmpty
                          ? utext(
                              title: File(state.image)
                                  .uri
                                  .pathSegments
                                  .last
                                  .substring(max(0, File(state.image).uri.pathSegments.last.length - 25)))
                          : utext(title: "Photo"),
                    ],
                  ),
                  const Icon(Icons.navigate_next_sharp, color: AppTheme.rightarrow),
                ],
              ),
            ),
          );
        },
      ));
    });
  }
}

class BuildPiority extends StatelessWidget {
  const BuildPiority({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<CollectionAddBloc, CollectionAddState>(
      buildWhen: (previous, current) => previous.model.piority != current.model.piority,
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                const Icon(FontAwesomeIcons.listOl, color: AppTheme.rightarrow, size: 17),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    key: const Key('piorityForm_firstInput_textField'),
                    onChanged: (piority) =>
                        context.read<CollectionAddBloc>().add(CollectionPiorityChanged(int.parse(piority))),
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

class BuildTitle extends StatelessWidget {
  const BuildTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<CollectionAddBloc, CollectionAddState>(
      buildWhen: (previous, current) => previous.model.title != current.model.title,
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                const Icon(FontAwesomeIcons.solidNoteSticky, color: AppTheme.rightarrow, size: 17),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    key: const Key('titleForm_firstInput_textField'),
                    onChanged: (name) => context.read<CollectionAddBloc>().add(CollectionTitleChanged(name)),
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

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<CollectionAddBloc, CollectionAddState>(
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
                                context.read<CollectionAddBloc>().add(const CollectionAddSubmitted());
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
