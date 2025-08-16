import 'package:flutter/material.dart';

class ErrorService {
  static void handleError(BuildContext context, Object error, StackTrace stackTrace) {
    // Show a user-friendly error message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An unexpected error occurred. Please try again later.'),
      ),
    );
  }
}
