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

import 'package:cazuapp_admin/models/collection.dart';
import 'package:cazuapp_admin/views/collections/collection_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/utext.dart';
import '../../core/theme.dart';

class CollectionItem extends StatelessWidget {
  const CollectionItem({required this.collection, super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixed = ScreenUtil().scaleWidth;

    return InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (_) => CollectionInfoPage(id: collection.id)));
        },
        child: Padding(
            padding: EdgeInsets.only(
                top: size.width * 0.01,
                bottom: size.height * 0.01,
                left: size.height * 0.01,
                right: size.height * 0.00),
            child: Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: ScreenUtil().setHeight(120.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(120.0),
                      width: ScreenUtil().setWidth(120.0),
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5.0)],
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(0.0), bottomRight: Radius.circular(0.0)),
                          image: DecorationImage(
                              image: NetworkImage(collection.imagesrc),
                              fit: BoxFit.fitHeight,
                              onError: (error, stackTrace) => const AssetImage('assets/null.png'))),
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0, left: 15.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          utext(
                              fontSize: fixed * 14,
                              title: collection.title,
                              color: AppTheme.black,
                              fontWeight: FontWeight.w600,
                              align: Alignment.bottomLeft,
                              textAlign: TextAlign.left),
                          const SizedBox(height: 10),
                          utext(
                              fontSize: fixed * 14,
                              title: "ID #${collection.id.toString()}",
                              color: AppTheme.orange,
                              fontWeight: FontWeight.w500,
                              align: Alignment.bottomLeft,
                              textAlign: TextAlign.left),
                          utext(
                              fontSize: fixed * 14,
                              title: "Piority ${collection.piority.toString()}",
                              color: AppTheme.black,
                              fontWeight: FontWeight.w200,
                              align: Alignment.bottomLeft,
                              textAlign: TextAlign.left),
                        ]),
                      ),
                    )
                  ],
                ))));
  }
}
