import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({required this.error, required this.reload, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //FIXME - refactor... not working
    return Column(
      children: [
        Text(error),
        ElevatedButton(
          onPressed: reload,
          child: Text(R.strings.reload),
        ),
      ],
    );
  }
}
