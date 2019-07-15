import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PageSwitcher extends StatefulWidget {
  final Widget firstPage;
  final Widget secondPage;
  final ValueListenable<Page> pageListenable;

  const PageSwitcher(
      {Key key,
      @required this.firstPage,
      @required this.secondPage,
      @required this.pageListenable})
      : assert(firstPage != null),
        assert(secondPage != null),
        assert(pageListenable != null),
        super(key: key);

  @override
  PageSwitcherState createState() => PageSwitcherState();
}

class PageSwitcherState extends State<PageSwitcher>
    with SingleTickerProviderStateMixin<PageSwitcher> {
  AnimationController _controller;
  Animation<Offset> _pageOnePosition;
  Animation<Offset> _pageTwoPosition;

  Page _pageValue;

  @override
  void didUpdateWidget(PageSwitcher oldWidget) {
    if (oldWidget.pageListenable != widget.pageListenable) {
      oldWidget.pageListenable.removeListener(_pageChanged);
      _pageValue = widget.pageListenable.value;
      widget.pageListenable.addListener(_pageChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _pageOnePosition = _controller.drive(Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    )));

    _pageTwoPosition = _controller.drive(Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(1.0, 0.0),
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    )));

    _pageValue = widget.pageListenable.value;
    widget.pageListenable.addListener(_pageChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: SlideTransition(
            position: _pageOnePosition,
            child: widget.firstPage,
          ),
        ),
        Positioned.fill(
          child: SlideTransition(
            position: _pageTwoPosition,
            child: widget.secondPage,
          ),
        ),
      ],
    );
  }

  void switchPages() {
    switch (_controller.status) {
      case AnimationStatus.dismissed:
        _controller.forward();
        break;
      case AnimationStatus.forward:
        _controller.reverse();
        break;
      case AnimationStatus.reverse:
        _controller.forward();
        break;
      case AnimationStatus.completed:
        _controller.reverse();
        break;
    }
  }

  void _pageChanged() {
    setState(() {
      _pageValue = widget.pageListenable.value;
      switch (_pageValue) {
        case Page.first:
          switch (_controller.status) {
            case AnimationStatus.dismissed:
            case AnimationStatus.reverse:
              // do nothing
              break;
            case AnimationStatus.forward:
            case AnimationStatus.completed:
              _controller.reverse();
              break;
          }
          break;
        case Page.second:
          switch (_controller.status) {
            case AnimationStatus.dismissed:
            case AnimationStatus.reverse:
              _controller.forward();
              break;
            case AnimationStatus.forward:
            case AnimationStatus.completed:
              //do nothing
              break;
          }
          break;
      }
    });
  }
}

enum Page { first, second }
