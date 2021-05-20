import 'package:flutter/material.dart';

class StarBar extends StatefulWidget {
  final int level;
  final int total;
  final String selectedImage;
  final String defaultImage;
  final bool canSelect;
  final double margin;
  final Function(int level) callback;

  const StarBar({
    Key key,
    @required this.level,
    @required this.selectedImage,
    this.defaultImage,
    this.canSelect = false,
    this.margin = 10,
    this.total = 5,
    this.callback,
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
  void didUpdateWidget(StarBar oldWidget) {
    _currentLevel = widget.level;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(
      widget.total,
      (index) => _imageItem(
          index < _currentLevel ? widget.selectedImage : widget.defaultImage,
          index),
    ).toList();

    return Row(
      children: stars,
    );
  }

  Widget _imageItem(String name, int index) {
    return Padding(
      padding: EdgeInsets.only(
          right: name == null ||
                  (widget.defaultImage == null && _currentLevel == index + 1)
              ? 0
              : widget.margin),
      child: name == null
          ? null
          : GestureDetector(
              onTap: () {
                if (widget.canSelect)
                  setState(() {
                    _currentLevel = index + 1;
                    if (widget?.callback != null)
                      widget.callback(_currentLevel);
                  });
              },
              child: Image.asset(name),
            ),
    );
  }
}
