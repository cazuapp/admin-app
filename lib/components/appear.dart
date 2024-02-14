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

import 'dart:async';

import 'package:flutter/material.dart';

/* Function to navigate to a specified page with a fast appear effect */
Future<void> appear(BuildContext context, Widget destinationPage, {bool root = true}) {
  // Create a Completer to handle the future result
  Completer<void> completer = Completer<void>();

  // Push a custom page route with a fast appear effect (fade transition)
  Navigator.of(context, rootNavigator: root)
      .push(
    PageRouteBuilder(
      // Build the destination page
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,

      // Define the fade transition animation with a very short duration
      transitionDuration: const Duration(milliseconds: 200), // Short duration for fast appearance
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the opacity animation
        var opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

        // Apply the fade transition to the child widget
        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
    ),
  )
      .then((result) {
    // Complete the future with a null result
    completer.complete(result);
  });

  // Return the Future for external use
  return completer.future;
}
