import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class SimpleMapMarker extends StatefulWidget {
  final String price;
  final VoidCallback? onTap;

  const SimpleMapMarker({
    super.key,
    required this.price,
    this.onTap,
  });

  @override
  State<SimpleMapMarker> createState() => _SimpleMapMarkerState();
}

class _SimpleMapMarkerState extends State<SimpleMapMarker> with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 90,
        height: 55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.push_pin_outlined,
              color: colorScheme.secondary,
              size: 30,
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.price,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
