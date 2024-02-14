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

enum BanSearchStatus { loading, initial, success, failure }

class BanSearchState extends Equatable {
  final BanSearchStatus status;
  final bool hasReachedMax;
  final List<BanListItem> bans;
  final int total;
  final String text;
  final Param param;

  const BanSearchState({
    this.status = BanSearchStatus.initial,
    this.hasReachedMax = false,
    this.bans = const <BanListItem>[],
    this.total = 0,
    this.text = '',
    this.param = Param.all,
  });

  BanSearchState copyWith({
    String? text,
    Param? param,
    BanSearchStatus? status,
    int? total,
    List<BanListItem>? bans,
    bool? hasReachedMax,
  }) {
    return BanSearchState(
      param: param ?? this.param,
      text: text ?? this.text,
      status: status ?? this.status,
      total: total ?? this.total,
      bans: bans ?? this.bans,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, bans, total, hasReachedMax, text, param];
}
