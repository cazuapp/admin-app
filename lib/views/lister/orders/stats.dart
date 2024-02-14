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
import 'package:cazuapp_admin/components/item_extended.dart';
import 'package:cazuapp_admin/components/progress.dart';
import 'package:cazuapp_admin/components/topbar.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';

const String title = "Order Stats";

class OrderStatsPage extends StatelessWidget {
  const OrderStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ServerInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(const FetchOrderStats()))
      ],
      child: const HomeList(),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerInfoBloc, ServerInfoState>(builder: (context, state) {
      double nodriver = state.orderStats.nodriver.toDouble();
      double pending = state.orderStats.pending.toDouble();
      double nopayment = state.orderStats.nopayment.toDouble();
      double cancelled = state.orderStats.cancelled.toDouble();
      double other = state.orderStats.other.toDouble();

      return BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups:
              barGroups(nodriver: nodriver, pending: pending, nopayment: nopayment, cancelled: cancelled, other: other),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceEvenly,
        ),
      );
    });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: AppTheme.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'P';
        break;
      case 1:
        text = 'ND';
        break;
      case 2:
        text = 'C';
        break;
      case 3:
        text = 'O';
        break;
      case 4:
        text = 'NP';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
        axisSide: meta.axisSide, space: 4, child: utext(title: text, fontSize: 13, fontWeight: FontWeight.w600));
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppTheme.black,
          AppTheme.focuschill,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> barGroups(
          {double nodriver = 0, double cancelled = 0, double pending = 0, double other = 0, double nopayment = 0}) =>
      [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: pending,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: nodriver,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: cancelled,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: other,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: nopayment,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.7,
      child: _BarChart(),
    );
  }
}

class HomeList extends StatelessWidget {
  const HomeList({super.key});

  Widget buildItemExtended(String input, IconData iconSrc, String title) {
    return ItemExtended(
      input: input,
      iconsrc: iconSrc,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ServerInfoBloc, ServerInfoState>(
      builder: (context, state) {
        switch (state.status) {
          case ServerInfoStatus.initial:
          case ServerInfoStatus.loading:
            return const Loader();
          case ServerInfoStatus.failure:
            return const Text('Failure to load data');
          case ServerInfoStatus.success:
            if (state.orderStats.all == 0) {
              return const FailurePage(title: "Title", subtitle: "No orders found.");
            }

            return Scaffold(
              appBar: const TopBar(title: title),
              backgroundColor: AppTheme.mainbg,
              body: SafeArea(
                child: SizedBox(
                  height: size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.03,
                          ),
                          child: utext(
                            title: "Today's Orders",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const BarChartSample3(),
                        const SizedBox(height: 10),
                        const AppDivisor(),
                        buildItemExtended("Pending (P)", Icons.hourglass_bottom, state.orderStats.pending.toString()),
                        buildItemExtended("No Driver (ND)", Icons.directions_car, state.orderStats.nodriver.toString()),
                        buildItemExtended("Cancelled (C)", Icons.cancel, state.orderStats.cancelled.toString()),
                        buildItemExtended("Other (O)", Icons.more_horiz, state.orderStats.other.toString()),
                        buildItemExtended("No Payment (NP)", Icons.payment, state.orderStats.nopayment.toString()),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
