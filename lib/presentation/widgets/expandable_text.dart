import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const ExpandableText(this.text, {super.key, this.style});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _isOverflowing = false;

  final _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final textRenderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (textRenderBox != null && mounted) {
      final size = textRenderBox.size;
      final textSpan = TextSpan(
        text: widget.text,
        style: widget.style ?? const TextStyle(fontSize: 14),
      );

      final textPainter = TextPainter(
        text: textSpan,
        maxLines: 2,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);

      setState(() {
        _isOverflowing = textPainter.didExceedMaxLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          key: _textKey,
          maxLines: _expanded ? null : 2,
          overflow: TextOverflow.fade,
          style: textStyle,
        ),
        if (_isOverflowing)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? "See less" : "See more",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          )
      ],
    );
  }
}
