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

part of 'bloc.dart';

enum BanHomeStatus { loading, initial, success, failure }

class BansHomeState extends Equatable {
  final BanHomeStatus status;
  final bool hasReachedMax;
  final List<BanListItem> bans;
  final int total;
  final Param param;
  final String text;

  const BansHomeState({
    this.status = BanHomeStatus.initial,
    this.total = 0,
    this.hasReachedMax = false,
    this.bans = const <BanListItem>[],
    this.param = Param.pending,
    this.text = "",
  });

  BansHomeState copyWith({
    BanHomeStatus? status,
    String? text,
    List<BanListItem>? bans,
    int? total,
    bool? hasReachedMax,
    Param? param,
  }) {
    return BansHomeState(
      param: param ?? this.param,
      total: total ?? this.total,
      text: text ?? this.text,
      status: status ?? this.status,
      bans: bans ?? this.bans,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''BanHomeStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, total, bans, hasReachedMax, param, text];
}
