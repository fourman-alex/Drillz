import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PageSwitcher extends StatefulWidget {
  final Widget child;

  const PageSwitcher({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  PageSwitcherState createState() => PageSwitcherState();
}

class PageSwitcherState extends State<PageSwitcher>
    with SingleTickerProviderStateMixin<PageSwitcher> {
  AnimationController _controller;
  Animation<Offset> _pageOnePosition;
  Animation<Offset> _pageTwoPosition;

  Widget _currentPage;
  Widget _nextPage;

  @override
  void didUpdateWidget(PageSwitcher oldWidget) {
    if (oldWidget.child != widget.child) {
      _currentPage = oldWidget.child;
      _nextPage = widget.child;
      _controller.forward(from: 0.0);
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

    _currentPage = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: SlideTransition(
            position: _pageOnePosition,
            child: _currentPage,
          ),
        ),
        Positioned.fill(
          child: SlideTransition(
            position: _pageTwoPosition,
            child: _nextPage,
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

//  void _pageChanged() {
//    setState(() {
//      _pageValue = widget.pageListenable.value;
//      switch (_pageValue) {
//        case Page.first:
//          switch (_controller.status) {
//            case AnimationStatus.dismissed:
//            case AnimationStatus.reverse:
//              // do nothing
//              break;
//            case AnimationStatus.forward:
//            case AnimationStatus.completed:
//              _controller.reverse();
//              break;
//          }
//          break;
//        case Page.second:
//          switch (_controller.status) {
//            case AnimationStatus.dismissed:
//            case AnimationStatus.reverse:
//              _controller.forward();
//              break;
//            case AnimationStatus.forward:
//            case AnimationStatus.completed:
//              //do nothing
//              break;
//          }
//          break;
//      }
//    });
//  }
}

enum Page { first, second }
