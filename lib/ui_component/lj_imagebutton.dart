import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ImageButtonPosition { left, up, right, bottom }

enum ImageTextAlign { centerLeft, center, centerRight }

enum ImageButtonState {
  normal,
  highlight,
  selected,
  disable,
}

class ImageButton extends StatefulWidget {
  ImageButton({
    Key key,
    @required this.imageChild,
    @required this.textChild,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.decoration,
    this.backgroundColor,
    this.highlightImageChild,
    this.highlightTextChild,
    this.highlightBackgroundColor,
    this.selectedImageChild,
    this.selectedTextChild,
    this.selectedBackgroundColor,
    this.disableImageChild,
    this.disableTextChild,
    this.disableBackgroundColor,
    this.spaceMargin = 0,
    this.position = ImageButtonPosition.left,
    this.state = ImageButtonState.normal,
    this.onTap,
    this.imageAnimationBegin,
    this.imageAnimationEnd,
    this.forwardOrReverseValueNotifier,
    this.imageTextAlign = ImageTextAlign.center,
  });

  final EdgeInsets padding;
  final BoxDecoration decoration;
  final double width;
  final double height;
  final Alignment alignment;
  final Widget textChild;
  final Widget imageChild;
  final Color backgroundColor;
  final Widget highlightImageChild;
  final Widget highlightTextChild;
  final Color highlightBackgroundColor;
  final Widget selectedImageChild;
  final Widget selectedTextChild;
  final Color selectedBackgroundColor;
  final Widget disableImageChild;
  final Widget disableTextChild;
  final Color disableBackgroundColor;
  final double spaceMargin;
  final ImageButtonPosition position;
  final ImageButtonState state;
  final GestureTapCallback onTap;
  final double imageAnimationBegin;
  final double imageAnimationEnd;
  final ValueNotifier<bool> forwardOrReverseValueNotifier;
  final ImageTextAlign imageTextAlign;

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton>
    with SingleTickerProviderStateMixin {
  ImageButtonState _state;
  ImageButtonState _lastState;

  AnimationController _animationController;
  Animation _animation;
  ValueNotifier<bool> _valueNotifier;

  @override
  void initState() {
    super.initState();

    _state = widget.state;

    _valueNotifier = widget.forwardOrReverseValueNotifier ?? ValueNotifier(false);

    if (widget.imageAnimationBegin != null &&
        widget.imageAnimationEnd != null) {
      _animationController = AnimationController(
          duration: Duration(milliseconds: 300), vsync: this);
      _animation = Tween(
          begin: widget.imageAnimationBegin, end: widget.imageAnimationEnd)
          .animate(_animationController);

      _valueNotifier.addListener(() {
        setState(() {
          _valueNotifier.value ?
          _animationController.forward() :
          _animationController.reverse();
        });
      });
    }
  }

  @override
  void didUpdateWidget(ImageButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    _state = widget.state;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
    widget.forwardOrReverseValueNotifier?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor;
    Widget _textChild;
    Widget _imageChild;

    switch (_state) {
      case ImageButtonState.normal:
        _backgroundColor = widget.backgroundColor;
        _textChild = widget.textChild;
        _imageChild = widget.imageChild;
        break;
      case ImageButtonState.highlight:
        _backgroundColor =
            widget.highlightBackgroundColor ?? widget.backgroundColor;
        _textChild = widget.highlightTextChild ?? widget.textChild;
        _imageChild = widget.highlightImageChild ?? widget.imageChild;
        break;
      case ImageButtonState.selected:
        _backgroundColor =
            widget.selectedBackgroundColor ?? widget.backgroundColor;
        _textChild = widget.selectedTextChild ?? widget.textChild;
        _imageChild = widget.selectedImageChild ?? widget.imageChild;
        break;
      case ImageButtonState.disable:
        _backgroundColor =
            widget.disableBackgroundColor ?? widget.backgroundColor;
        _textChild = widget.disableImageChild ?? widget.textChild;
        _imageChild = widget.disableImageChild ?? widget.imageChild;
        break;
    }

    if (_animationController != null) {
      _imageChild = RotationTransition(
        turns: _animation,
        child: _imageChild,
      );
    }

    CrossAxisAlignment crossAxisAlignment;
    switch (widget.imageTextAlign) {
      case ImageTextAlign.centerLeft:
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case ImageTextAlign.center:
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
      case ImageTextAlign.centerRight:
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
    }

    Widget current;
    switch (widget.position) {
      case ImageButtonPosition.left:
        current = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: <Widget>[
                _imageChild,
                Container(
                  width: widget.spaceMargin,
                ),
                _textChild,
              ],
            ),
          ],
        );
        break;
      case ImageButtonPosition.up:
        current = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: <Widget>[
                _imageChild,
                Container(
                  height: widget.spaceMargin,
                ),
                _textChild
              ],
            ),
          ],
        );
        break;
      case ImageButtonPosition.right:
        current = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: <Widget>[
                _textChild,
                Container(
                  width: widget.spaceMargin,
                ),
                _imageChild,
              ],
            ),
          ],
        );
        break;
      case ImageButtonPosition.bottom:
        current = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: <Widget>[
                _textChild,
                Container(
                  height: widget.spaceMargin,
                ),
                _imageChild,
              ],
            ),
          ],
        );
        break;
    }

    return GestureDetector(
      child: Container(
        padding: widget.padding,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment,
        decoration: widget.decoration?.copyWith(
          color: _backgroundColor,
        ) ?? BoxDecoration(color: _backgroundColor),
        child: current,
      ),
      onTap: (widget.onTap == null || _state == ImageButtonState.disable) ? null : () {
//        _valueNotifier.value = !_valueNotifier.value;
        widget.onTap?.call();
      },
      onTapDown: widget.onTap == null || _state == ImageButtonState.disable ? null : (
          TapDownDetails details) {
        _lastState = _state;
        _state = ImageButtonState.highlight;
        setState(() {});
      },
      onTapUp: widget.onTap == null || _state == ImageButtonState.disable ? null : (
          TapUpDetails details) {
        _state = _lastState;
        setState(() {});
      },
      onTapCancel:widget.onTap == null ||  _state == ImageButtonState.disable ? null : () {
        _state = _lastState;
        setState(() {});
      },
    );
  }
}
