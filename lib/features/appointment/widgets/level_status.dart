import 'package:flutter/material.dart';
import 'package:win_field_sale/features/appointment/widgets/capsule_widget.dart';

class LevelStatus extends StatelessWidget {
  final String levelStatusName;

  const LevelStatus({required this.levelStatusName, super.key});

  @override
  Widget build(BuildContext context) {
    return CapsuleWidget(label: levelStatusName, capsuleStyle: CapsuleStyle(Color(0xFF0689FF), Color.fromRGBO(47, 128, 237, 0.2)));
  }
}
