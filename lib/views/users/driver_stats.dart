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

import 'package:cazuapp_admin/bloc/server/info/bloc.dart';
import 'package:cazuapp_admin/components/divisor.dart';
import 'package:cazuapp_admin/components/failure.dart';
import 'package:cazuapp_admin/components/indicator.dart';
import 'package:cazuapp_admin/components/item_extended.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/topbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../core/theme.dart';

import '../../../components/utext.dart';

const String title = "Driver Stats";

class DriverStatsPage extends StatelessWidget {
  const DriverStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ServerInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(const FetchDriverStats()))
      ],
      child: const HomeList(),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerInfoBloc, ServerInfoState>(builder: (context, state) {
      return AspectRatio(
        aspectRatio: 1.7,
        child: Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(state.driverStats.no.toDouble(), state.driverStats.yes.toDouble()),
                  ),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: AppTheme.remove,
                  text: 'Not available',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppTheme.focuschill2,
                  text: 'Available',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
            const SizedBox(
              width: 18,
            ),
          ],
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections(double no, double yes) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppTheme.remove,
            value: no,
            title: '$no%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppTheme.focuschill2,
            value: yes,
            title: '$yes%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}

class HomeList extends StatelessWidget {
  const HomeList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ServerInfoBloc, ServerInfoState>(
      builder: (context, state) {
        switch (state.status) {
          case ServerInfoStatus.initial:
            return const Loader();
          case ServerInfoStatus.loading:
            return const Loader();
          case ServerInfoStatus.success:
            if (state.driverStats.all == 0) {
              return const FailurePage(title: title, subtitle: "No drivers found.");
            }
            break;
          case ServerInfoStatus.failure:
            break;
        }

        return Scaffold(
            appBar: const TopBar(title: title),
            backgroundColor: AppTheme.mainbg,
            body: SafeArea(
                child: SizedBox(
                    height: size.height,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.03),
                          child: Column(children: [
                            utext(title: "Available drivers", fontWeight: FontWeight.w700),
                            utext(title: "${state.driverStats.all.toString()} in total", fontWeight: FontWeight.w300),
                          ])),
                      const PieChartSample2(),
                      const SizedBox(height: 10),
                      const AppDivisor(),
                      ItemExtended(
                          input: "Total drivers",
                          iconsrc: Icons.directions_car,
                          title: state.driverStats.all.toString()),
                      ItemExtended(
                          input: "Available",
                          iconsrc: Icons.check_circle_outline,
                          title: state.driverStats.yes.toString()),
                      ItemExtended(
                          input: "Not Available", iconsrc: Icons.cancel, title: state.driverStats.no.toString()),
                    ])))
                //)
                ));
      },
    );
  }
}
