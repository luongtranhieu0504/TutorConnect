import 'package:flutter/material.dart';

import '../../theme/text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            child: Divider(
              color: Color(0xFFCBD5E1),
              thickness: 1,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("OR", style: AppTextStyles(context).bodyText1.copyWith(color: Color(0xFFCBD5E1)))
          ),
          Expanded(
            child: Divider(
              color: Color(0xFFCBD5E1),
              thickness: 1,
            ),
          )
        ]
    );
  }
}
