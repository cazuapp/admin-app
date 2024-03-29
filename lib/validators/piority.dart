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

import 'package:formz/formz.dart';

enum PiorityValidationError { invalid }

class Piority extends FormzInput<int, PiorityValidationError> {
  const Piority.pure([super.value = 0]) : super.pure();
  const Piority.dirty([super.value = 0]) : super.dirty();

  @override
  PiorityValidationError? validator(int? value) {
    if (value == 0) {
      return PiorityValidationError.invalid;
    } else {
      return null;
    }
  }
}
