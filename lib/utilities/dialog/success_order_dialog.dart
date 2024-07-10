import 'package:carx/features/presentation/order_success/order_success_view.dart';
import 'package:flutter/material.dart';

Future<void> showBookingSuccessDialog({
  required BuildContext context,
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Booking success'),
        content: const Text('content'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const OrderSucess(),
              ));
            },
            child: const Text('Views'),
          )
        ],
      );
    },
  );
}
