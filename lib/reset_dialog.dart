import 'package:drillz/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';

class ResetDialog extends StatefulWidget {
  const ResetDialog({Key? key}) : super(key: key);

  @override
  _ResetDialogState createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  late Map<WorkoutType, bool> switched;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.fromLTRB(12, 16, 8, 0),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      title: const Text('Reset Workout'),
      children: <Widget>[
        for (final type in switched.keys)
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(type.name),
                Switch(
                    value: switched[type]!,
                    onChanged: (value) {
                      setState(() {
                        switched[type] = value;
                      });
                    })
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                final List<WorkoutType> res = switched.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList(growable: false);
                Navigator.of(context).pop(res);
              },
              child: const Text('RESET'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            )
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    final repo = context.read<Repository>();
    final workoutTypes = repo.model.plans.keys.toList(growable: false);
    switched = {
      for (final type in workoutTypes) type: false,
    };
  }
}
