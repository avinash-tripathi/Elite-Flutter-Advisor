import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/providers/paymentmethod_provider.dart';

class CardTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width; // Added width parameter

  const CardTab({required this.icon, required this.label, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      padding: const EdgeInsets.all(8.0),
      child:
          Consumer<PaymentMethodProvider>(builder: (context, prvMethod, child) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
                color:
                    ((prvMethod.selectedMethod == 'Card' && label == 'Card') ||
                            (prvMethod.selectedMethod == 'Bank' &&
                                label == 'US Bank'))
                        ? AppColors.blue
                        : AppColors.conversation,
                width: 2), // Set border color and width
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 5),
              Container(
                // Adjust the padding to fit the content within the card
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Handle label overflow
                  maxLines: 2, // Maximum lines for the label
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
