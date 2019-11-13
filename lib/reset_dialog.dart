import 'package:drillz/model.dart';
import 'package:flutter/material.dart';

class ResetDialog extends StatefulWidget {
  @override
  _ResetDialogState createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  bool _situpsSwitch = false;
  bool _pullupsSwitch = false;
  bool _pushupsSwitch = false;
  bool _squatsSwitch = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.fromLTRB(12, 16, 8, 0),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      title: const Text('Reset Workout'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Pushups'),
              Switch(
                  value: _pushupsSwitch,
                  onChanged: (bool value) {
                    setState(() {
                      _pushupsSwitch = value;
                    });
                  })
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Pullups'),
              Switch(
                  value: _pullupsSwitch,
                  onChanged: (bool value) {
                    setState(() {
                      _pullupsSwitch = value;
                    });
                  })
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Situps'),
              Switch(
                  value: _situpsSwitch,
                  onChanged: (bool value) {
                    setState(() {
                      _situpsSwitch = value;
                    });
                  })
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Squats'),
              Switch(
                  value: _squatsSwitch,
                  onChanged: (bool value) {
                    setState(() {
                      _squatsSwitch = value;
                    });
                  })
            ],
          ),
        ),
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                final List<WorkoutType> res = <WorkoutType>[
                  if (_situpsSwitch) WorkoutType.situps,
                  if (_squatsSwitch) WorkoutType.squats,
                  if (_pullupsSwitch) WorkoutType.pullups,
                  if (_pushupsSwitch) WorkoutType.pushups,
                ];
                Navigator.of(context).pop(res);
              },
              child: const Text('RESET'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        )
      ],
    );
  }
}
