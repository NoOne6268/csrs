import 'package:flutter/material.dart';

enum SnackbarType { success, failure, info }

class CustomSnackbar extends StatelessWidget {
  final String title;
  final String message;
  final SnackbarType type;

  CustomSnackbar({
    required this.title,
    required this.message,
    required this.type,
  });

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.failure:
        return Colors.red;
      case SnackbarType.info:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.failure:
        return Icons.error;
      case SnackbarType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: _getBackgroundColor(context),
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(_getIcon(), color: Colors.white),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
