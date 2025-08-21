import 'package:flutter/material.dart';
import 'package:win_field_sale/features/appointment/widgets/capsule_widget.dart';

class LevelStatus extends StatelessWidget {
  final String levelStatusName;

  const LevelStatus({required this.levelStatusName, super.key});

  @override
  Widget build(BuildContext context) {
    const capsuleStyles = <String, CapsuleStyle>{
      'A': CapsuleStyle(Color(0xFF0689FF), Color.fromRGBO(47, 128, 237, 0.2)),
      'B': CapsuleStyle(Color(0xFF0689FF), Color.fromRGBO(47, 128, 237, 0.2)),
      'C': CapsuleStyle(Color(0xFF0689FF), Color.fromRGBO(47, 128, 237, 0.2)),
      'D': CapsuleStyle(Color(0xFF0689FF), Color.fromRGBO(47, 128, 237, 0.2)),
    };

    final capsuleStyle = capsuleStyles[levelStatusName] ?? CapsuleStyle(Color(0xFFEEEEEE), Color(0xFFEEEEEE));

    return CapsuleWidget(label: levelStatusName, capsuleStyle: capsuleStyle);
  }
}
