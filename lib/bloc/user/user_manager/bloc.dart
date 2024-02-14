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

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cazuapp_admin/components/dual.dart';
import 'package:cazuapp_admin/components/etc.dart';
import 'package:cazuapp_admin/models/ban.dart';
import 'package:cazuapp_admin/models/user_extend.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/protocol.dart';

import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserManagerBloc extends Bloc<UserFetchEvent, UserManagerState> {
  final AppInstance instance;

  UserManagerBloc({required this.instance}) : super(UserManagerState.initial()) {
    on<UserInfoRequest>(_onRequest);
    on<UserManagerOK>(_userManagerOK);
    on<UserSetDriverStatus>(_onSetDriverStatus);
    on<UserManageDriver>(_onManageDriver);
    on<UserManageHold>(_onManageHolds);
    on<WhoAmi>(_onWhoAmi);
    on<SetFlag>(_onSetFlag);
    on<BanInfo>(_onBanInfo);
    on<SetBan>(_onBanSet);
    on<Load>(_onLoad);

    on<AssignOrder>(_onAssignOrder);
  }

  Future<void> _onLoad(Load event, Emitter<UserManagerState> emit) async {
    emit(state.copyWith(current: UserStatus.loading));
  }

  Future<void> _onBanSet(SetBan event, Emitter<UserManagerState> emit) async {
    final id = event.id;
    final code = event.code;

    DualResult? result;

    if (code != BanCodeStatus.noban) {
      result = await instance.bans.setban(id: id, code: code);
    } else {
      result = await instance.bans.delete(id: id);
    }

    if (result?.status == Protocol.ok) {
      emit(state.copyWith(current: UserStatus.success, status: result?.status, radio: code));
    } else {
      emit(state.copyWith(current: UserStatus.failure, status: result?.status));
    }
  }

  Future<void> _onBanInfo(BanInfo event, Emitter<UserManagerState> emit) async {
    final user = event.id;

    try {
      DualResult? result = await instance.bans.info(id: user);

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(
            current: UserStatus.success,
            status: result?.status,
            user: result?.model,
            radio: Etc.convertBan(result?.model.banCode)));
      } else {
        emit(state.copyWith(current: UserStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(current: UserStatus.failure, status: Protocol.unknownError));
    }
  }

  Future<void> _onAssignOrder(AssignOrder event, Emitter<UserManagerState> emit) async {
    final order = event.order;
    final user = event.user;

    try {
      DualResult? result = await instance.users.take(order: order, user: user);

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(current: UserStatus.success, status: result?.status, user: result?.model));
      } else {
        emit(state.copyWith(current: UserStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(current: UserStatus.failure, status: Protocol.unknownError));
    }
  }

  Future<void> _onSetFlag(SetFlag event, Emitter<UserManagerState> emit) async {
    final status = event.status;
    final value = event.value;
    final id = event.user;

    try {
      DualResult? result = await instance.users.flagsUpsert(id: id, value: value, status: status);

      if (result?.status == Protocol.ok) {
        DualResult? result2 = await instance.users.info(id: id);

        emit(state.copyWith(current: UserStatus.success, status: result?.status, user: result2?.model));
      } else {
        emit(state.copyWith(current: UserStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(current: UserStatus.failure, status: Protocol.unknownError));
    }
  }

  Future<void> _userManagerOK(UserManagerOK event, Emitter<UserManagerState> emit) async {
    emit(UserManagerState.initial());
  }

  Future<void> _onWhoAmi(WhoAmi event, Emitter<UserManagerState> emit) async {
    await instance.auth.whoami();
    emit(state.copyWith(current: UserStatus.success));
  }

  Future<void> _onRequest(UserInfoRequest event, Emitter<UserManagerState> emit) async {
    final id = event.id;

    try {
      DualResult? result = await instance.users.info(id: id);

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(
            current: UserStatus.success,
            status: result?.status,
            user: result?.model,
            available: result?.model.isDriver));
      } else {
        emit(state.copyWith(current: UserStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(current: UserStatus.failure, status: Protocol.unknownError));
    }
  }

  Future<void> _onSetDriverStatus(UserSetDriverStatus event, Emitter<UserManagerState> emit) async {
    final action = event.status;

    bool? result = await instance.users.driverManage(id: state.user.id, status: action);

    emit(state.copyWith(current: UserStatus.success, available: result == true ? action : state.available));
  }

  Future<void> _onManageDriver(UserManageDriver event, Emitter<UserManagerState> emit) async {
    emit(state.copyWith(current: UserStatus.success, available: state.available));
  }

  Future<void> _onManageHolds(UserManageHold event, Emitter<UserManagerState> emit) async {
    final status = event.status;
    final type = event.type;

    try {
      if (type == "orders") {
        emit(state.copyWith(current: UserStatus.success, user: state.user.copyWith(ableToOrder: status)));
      } else {
        emit(state.copyWith(current: UserStatus.success, user: state.user.copyWith(health: status)));
      }

      DualResult? result = await instance.users
          .holdsManage(id: state.user.id, ableToOrder: state.user.ableToOrder, health: state.user.health);

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(current: UserStatus.success, status: result?.status));
      } else {
        emit(state.copyWith(current: UserStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(current: UserStatus.failure, status: Protocol.unknownError));
    }
  }
}
