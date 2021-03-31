

import 'package:flutter/material.dart';

class StarBar extends StatefulWidget {
  final int level;
  final int total;
  final String selectedImage;
  final String defaultImage;
  final bool canSelect;
  final double margin;

  const StarBar({
    Key key,
    @required this.level,
    @required this.selectedImage,
    this.defaultImage,
    this.canSelect = false,
    this.margin = 10,
    this.total = 5,
  }) : super(key: key);

  @override
  _StarBarState createState() => _StarBarState();
}

class _StarBarState extends State<StarBar> {
  int _currentLevel;

  @override
  void initState() {
    super.initState();

    _currentLevel = widget.level;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(
      widget.total,
      (index) => Padding(
        padding: EdgeInsets.only(right: widget.margin),
        child: _imageItem(
            index < _currentLevel ? widget.selectedImage : widget.defaultImage,
            index),
      ),
    ).toList();

    return Row(
      children: stars,
    );
  }

  Widget _imageItem(String name, int index) {
    if (name == null) return null;

    return GestureDetector(
      onTap: () {
        if (widget.canSelect)
          setState(() {
            _currentLevel = index + 1;
          });
      },
      child: Image.asset(name),
    );
  }
}