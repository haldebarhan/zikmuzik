import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zikmuzik/models/onboard_item.dart';

class OnboardItemWidget extends StatelessWidget {
  const OnboardItemWidget({super.key, required this.item});
  final OnboardItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: 20,
      children: [
        Lottie.asset(item.lottieUrl),
        Text(
          item.title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: .bold),
        ),
        Text(
          item.description,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: .center,
        ),
      ],
    );
  }
}
