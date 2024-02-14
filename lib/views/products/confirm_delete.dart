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

import 'package:cazuapp_admin/bloc/products/info/bloc.dart';
import 'package:cazuapp_admin/views/lister/products/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class DeleteProductConfirmPage extends StatelessWidget {
  final int id;

  const DeleteProductConfirmPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            ProductInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(FetchInfo(id: id)),
        child: const CloseAddressForm(),
      ),
    );
  }
}

class CloseAddressForm extends StatelessWidget {
  const CloseAddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<ProductInfoBloc, ProductInfoState>(listener: (context, state) {
      if (state.status == ProductInfoStatus.failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildAlert(state.errmsg));
      } else {
        if (state.status == ProductInfoStatus.deleted) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListPage()));
        }
      }
    }, child: BlocBuilder<ProductInfoBloc, ProductInfoState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.mainbg,
          appBar: TopBar(title: "Delete product: ${state.product.name}"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.12, vertical: size.height * 0.06),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.triangleExclamation, size: 60, color: AppTheme.softred),
                            const SizedBox(height: 4),
                            Expanded(
                                flex: 0,
                                child: Column(children: [
                                  utext(
                                      title: "Warning",
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.main,
                                      fontSize: 22,
                                      align: Alignment.center),
                                  const SizedBox(height: 15),
                                  utext(
                                      title:
                                          "If you remove this product, ALL variants associated with it will also be deleted.",
                                      fontSize: 15,
                                      textAlign: TextAlign.center,
                                      color: const Color.fromARGB(159, 18, 18, 18),
                                      align: Alignment.center),
                                  const SizedBox(height: 25),
                                  utext(
                                    align: Alignment.center,
                                    textAlign: TextAlign.center,
                                    title: "Do you really want to remove this product?",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: const Color.fromARGB(159, 18, 18, 18),
                                  ),
                                  const SizedBox(height: 25),
                                  const ConfirmButton(),
                                ]))
                          ])))));
    }));
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
      builder: (context, state) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
                icon: const Icon(
                  FontAwesomeIcons.rightLong,
                  color: AppTheme.mainbg,
                  size: 19.0,
                ),
                label: utext(
                    title: "Delete Product",
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.mainbg),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 10.0,
                  backgroundColor: AppTheme.softred,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                key: const Key('signupForm_continue_raisedButton'),
                onPressed: () {
                  context.read<ProductInfoBloc>().add(DeleteProduct(id: state.id));
                }));
      },
    );
  }
}
