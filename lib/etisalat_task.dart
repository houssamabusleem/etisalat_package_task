library etisalat_task;

import 'dart:math';

import 'package:flutter/material.dart';

enum SelectedItemAnchor { START, MIDDLE, END }

class HorizontalScroll extends StatefulWidget {
  final Color background;

  final Widget Function(BuildContext, int) itemBuilder;

  final Curve curve;

  final int duration;

  final double endOfListTolerance;

  final bool focusOnItemTap;

  final void Function(int) focusToItem;

  final EdgeInsetsGeometry margin;

  final int itemCount;

  final double itemSize;

  final Key key;

  final Key listViewKey;

  final void Function(int) onItemFocus;

  final Function onReachEnd;

  final EdgeInsetsGeometry padding;

  final bool reverse;

  final bool updateOnScroll;

  final double initialIndex;

  final Axis scrollDirection;

  final ScrollController listController;

  final bool dynamicItemSize;

  final double Function(double distance) dynamicSizeEquation;

  final double dynamicItemOpacity;

  final SelectedItemAnchor selectedItemAnchor;

  HorizontalScroll(
      {this.background,
      @required this.itemBuilder,
      ScrollController listController,
      this.curve = Curves.ease,
      this.duration = 500,
      this.endOfListTolerance,
      this.focusOnItemTap = true,
      this.focusToItem,
      this.itemCount,
      @required this.itemSize,
      this.key,
      this.listViewKey,
      this.margin,
      this.onItemFocus,
      this.onReachEnd,
      this.padding,
      this.reverse = false,
      this.updateOnScroll,
      this.initialIndex,
      this.scrollDirection = Axis.horizontal,
      this.dynamicItemSize = false,
      this.dynamicSizeEquation,
      this.dynamicItemOpacity,
      this.selectedItemAnchor = SelectedItemAnchor.MIDDLE})
      : listController = listController ?? ScrollController(),
        super(key: key);

  @override
  HorizontalScrollState createState() => HorizontalScrollState();
}

class HorizontalScrollState extends State<HorizontalScroll> {
  bool isInit = true;
  int previousIndex = -1;
  double currentPixel = 0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex != null) {
        focusToInitialPosition();
      } else {
        isInit = false;
      }
    });

    Future.delayed(Duration(milliseconds: 10), () {
      if (this.mounted) {
        setState(() {
          isInit = false;
        });
      }
    });
  }

  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      widget.listController.animateTo(
        location,
        duration: new Duration(milliseconds: widget.duration),
        curve: widget.curve,
      );
    });
  }

  double calculateScale(int index) {
    double intendedPixel = index * widget.itemSize;
    double difference = intendedPixel - currentPixel;

    if (widget.dynamicSizeEquation != null) {
      double scale = widget.dynamicSizeEquation(difference);
      return scale < 0 ? 0 : scale;
    }

    return 1 - min(difference.abs() / 500, 0.4);
  }

  double calculateOpacity(int index) {
    double intendedPixel = index * widget.itemSize;
    double difference = intendedPixel - currentPixel;

    return (difference == 0) ? 1.0 : widget.dynamicItemOpacity ?? 1.0;
  }

  Widget _buildListItem(BuildContext context, int index) {
    Widget child;
    if (widget.dynamicItemSize) {
      child = Transform.scale(
        scale: calculateScale(index),
        child: widget.itemBuilder(context, index),
      );
    } else {
      child = widget.itemBuilder(context, index);
    }

    if (widget.dynamicItemOpacity != null) {
      child = Opacity(child: child, opacity: calculateOpacity(index));
    }

    if (widget.focusOnItemTap)
      return GestureDetector(
        onTap: () => focusToItem(index),
        child: child,
      );

    return child;
  }

  double _calcCardLocation(
      {double pixel, @required double itemSize, int index}) {
    int cardIndex =
        index != null ? index : ((pixel - itemSize / 2) / itemSize).ceil();

    if (widget.onItemFocus != null && cardIndex != previousIndex) {
      previousIndex = cardIndex;
      widget.onItemFocus(cardIndex);
    }

    return (cardIndex * itemSize);
  }

  void focusToItem(int index) {
    double targetLoc =
        _calcCardLocation(index: index, itemSize: widget.itemSize);
    _animateScroll(targetLoc);
  }

  void focusToInitialPosition() {
    widget.listController.jumpTo((widget.initialIndex * widget.itemSize));
  }

  void _onReachEnd() {
    if (widget.onReachEnd != null) widget.onReachEnd();
  }

  @override
  void dispose() {
    widget.listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraint) {
          double _listPadding = 0;

          switch (widget.selectedItemAnchor) {
            case SelectedItemAnchor.START:
              _listPadding = 0;
              break;
            case SelectedItemAnchor.MIDDLE:
              _listPadding = (widget.scrollDirection == Axis.horizontal
                          ? constraint.maxWidth
                          : constraint.maxHeight) /
                      2 -
                  widget.itemSize / 2;
              break;
            case SelectedItemAnchor.END:
              _listPadding = (widget.scrollDirection == Axis.horizontal
                      ? constraint.maxWidth
                      : constraint.maxHeight) -
                  widget.itemSize;
              break;
          }

          return GestureDetector(
            onTapDown: (_) {},
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification) {
                  if (isInit) {
                    return true;
                  }

                  double tolerance =
                      widget.endOfListTolerance ?? (widget.itemSize / 2);
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - tolerance) {
                    _onReachEnd();
                  }

                  double offset = _calcCardLocation(
                    pixel: scrollInfo.metrics.pixels,
                    itemSize: widget.itemSize,
                  );

                  if ((scrollInfo.metrics.pixels - offset).abs() > 0.01) {
                    _animateScroll(offset);
                  }
                } else if (scrollInfo is ScrollUpdateNotification) {
                  if (widget.dynamicItemSize ||
                      widget.dynamicItemOpacity != null) {
                    setState(() {
                      currentPixel = scrollInfo.metrics.pixels;
                    });
                  }

                  if (widget.updateOnScroll == true) {
                    if (isInit) {
                      return true;
                    }

                    if (widget.onItemFocus != null && isInit == false) {
                      _calcCardLocation(
                        pixel: scrollInfo.metrics.pixels,
                        itemSize: widget.itemSize,
                      );
                    }
                  }
                }
                return true;
              },
              child: ListView.builder(
                key: widget.listViewKey,
                controller: widget.listController,
                padding: widget.scrollDirection == Axis.horizontal
                    ? EdgeInsets.symmetric(horizontal: _listPadding)
                    : EdgeInsets.symmetric(
                        vertical: _listPadding,
                      ),
                reverse: widget.reverse,
                scrollDirection: widget.scrollDirection,
                itemBuilder: _buildListItem,
                itemCount: widget.itemCount,
              ),
            ),
          );
        },
      ),
    );
  }
}
