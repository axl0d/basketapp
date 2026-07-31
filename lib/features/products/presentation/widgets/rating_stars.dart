import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  final double rating;
  final double starSize;
  final Function(double)? onRatingChanged;
  final bool readOnly;

  const RatingStars({
    super.key,
    required this.rating,
    this.starSize = 24,
    this.onRatingChanged,
    this.readOnly = false,
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late double _hoverRating;

  @override
  void initState() {
    super.initState();
    _hoverRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starRating = index + 1.0;
        final isHovering = !widget.readOnly && _hoverRating >= starRating;
        final isFilled = widget.rating >= starRating;

        return MouseRegion(
          onEnter: widget.readOnly
              ? null
              : (_) {
                  setState(() {
                    _hoverRating = starRating;
                  });
                },
          onExit: widget.readOnly
              ? null
              : (_) {
                  setState(() {
                    _hoverRating = widget.rating;
                  });
                },
          child: GestureDetector(
            onTap: widget.readOnly || widget.onRatingChanged == null
                ? null
                : () {
                    widget.onRatingChanged?.call(starRating);
                  },
            child: Icon(
              isHovering || isFilled ? Icons.star : Icons.star_border,
              size: widget.starSize,
              color: isHovering || isFilled ? Colors.amber : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}
