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
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Edit Workouts'),
      ),
      floatingActionButton: OpenContainer<WorkoutType?>(
        openSize: const Size(250, 150),
        openBuilder: (context, _) {
          return const _AddTypeDialog();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.primary,
        openColor: Theme.of(context).colorScheme.primary,
        closedBuilder: (context, openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
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
  const _AddTypeDialog({Key? key}) : super(key: key);

  @override
  _AddTypeDialogState createState() => _AddTypeDialogState();
}

class _AddTypeDialogState extends State<_AddTypeDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      WorkoutType? result;
                      if (_textController.value.text.isNotEmpty) {
                        result = WorkoutType(
                          id: _textController.value.text.toLowerCase(),
                          name: _textController.value.text,
                        );
                      }
                      Navigator.pop(context, result);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
