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

import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/utext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cazuapp_admin/bloc/user/auth/bloc.dart';
import 'package:cazuapp_admin/bloc/user/user_manager/bloc.dart';
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:cazuapp_admin/core/theme.dart';
import 'package:cazuapp_admin/models/user_extend.dart';

/* SetBanPage Displays current status on a given order */

class SetBanPage extends StatelessWidget {
  const SetBanPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => UserManagerBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance,
        )..add(BanInfo(id: id)),
        child: const RadioStatus(),
      ),
    );
  }
}

class RadioStatus extends StatefulWidget {
  const RadioStatus({super.key});

  @override
  State<RadioStatus> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioStatus> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FocusManager.instance.primaryFocus?.unfocus();

    return BlocBuilder<UserManagerBloc, UserManagerState>(
      builder: (context, state) {
        switch (state.current) {
          case UserStatus.initial:
          case UserStatus.loading:
            return const Loader();
          case UserStatus.failure:
            return const FailurePage(title: "Ban manager", subtitle: "Error loading ban");
          case UserStatus.success:
            break;
        }

        UserExtend user = state.user;

        return Scaffold(
          backgroundColor: AppTheme.white,
          appBar: TopBar(title: "Ban ${state.user.email.toString()}"),
          body: SafeArea(
            child: SizedBox(
              height: size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.02,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Container(
                        alignment: Alignment.topLeft,
                        child: utext(
                          fontSize: 14,
                          title: "Ban Status",
                          color: AppTheme.title,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildBanOption(
                        context,
                        user.id,
                        BanCodeStatus.noban,
                        Etc.fromBan(BanCodeStatus.noban.toShortString()),
                      ),
                      const Divider(),
                      _buildBanOption(
                        context,
                        user.id,
                        BanCodeStatus.badbehavior,
                        Etc.fromBan(BanCodeStatus.badbehavior.toShortString()),
                      ),
                      const Divider(),
                      _buildBanOption(
                        context,
                        user.id,
                        BanCodeStatus.badaction,
                        Etc.fromBan(BanCodeStatus.badaction.toShortString()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanOption(
    BuildContext context,
    int userId,
    BanCodeStatus code,
    String label,
  ) {
    return InkWell(
      onTap: () {
        context.read<UserManagerBloc>().add(SetBan(id: userId, code: code));
      },
      child: ListTile(
        title: utext(title: label),
        leading: Radio<BanCodeStatus>(
          value: code,
          groupValue: context.read<UserManagerBloc>().state.radio,
          onChanged: (BanCodeStatus? value) {
            context.read<UserManagerBloc>().add(SetBan(id: userId, code: code));
          },
        ),
      ),
    );
  }
}
