import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'open_container.dart';

import 'repository.dart';

const double _fabDimension = 56.0;

class EditWorkoutsPage extends StatelessWidget {
  const EditWorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<Repository>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Workouts'),
      ),
      floatingActionButton: OpenContainer<WorkoutType?>(
        openSize: const Size(250, 150),
        openBuilder: (context, _) {
          final themeData = ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                  primary: Colors.black, secondary: Colors.black));
          return _AddTypeDialog(themeData: themeData);
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.secondary,
        openColor: Theme.of(context).colorScheme.secondary,
        closedBuilder: (context, openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
        onClosed: (type) {
          if (type != null) {
            repo.addWorkoutType(type);
          }
        },
      ),
      body: ListView(
        children: [
          for (final type in repo.model.plans.keys)
            ListTile(
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => repo.removeWorkoutType(type),
              ),
              title: Text(type.name),
            )
        ],
      ),
    );
  }
}

class _AddTypeDialog extends StatefulWidget {
  const _AddTypeDialog({required this.themeData, Key? key}) : super(key: key);
  final ThemeData themeData;

  @override
  _AddTypeDialogState createState() => _AddTypeDialogState();
}

class _AddTypeDialogState extends State<_AddTypeDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.themeData,
      child: SizedBox.expand(
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(labelText: 'Workout Name'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        WorkoutType? result;
                        if (_textController.value.text.isNotEmpty) {
                          result = WorkoutType(
                              id: _textController.value.text.toLowerCase(),
                              name: _textController.value.text);
                        }
                        Navigator.pop(context, result);
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
