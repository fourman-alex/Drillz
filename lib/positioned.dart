import 'package:flutter/material.dart';
import 'package:pogo/fill_transition.dart';

class SelectionScreen extends StatefulWidget {
  final Rect sourceRect;

  const SelectionScreen({Key key, @required this.sourceRect})
      : assert(sourceRect != null),
        super(key: key);

  static Route<dynamic> route(BuildContext context, GlobalKey key) {
    final RenderBox box = key.currentContext.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) =>
          SelectionScreen(sourceRect: sourceRect),
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return FillTransition(
      source: widget.sourceRect,
      child: SizedBox.expand(
        child: Material(
          color: Colors.white,
          child: Text("Pushups ink"),
        ),
      ),
    );
  }
}
